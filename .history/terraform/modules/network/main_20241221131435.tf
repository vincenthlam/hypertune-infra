# modules/network/main.tf

# Core VCN
resource "oci_core_vcn" "mlops_vcn" {
  compartment_id = var.compartment_id
  display_name   = "mlops-vcn"
  cidr_blocks    = ["10.0.0.0/16"]
  dns_label      = "mlops"

  defined_tags = merge(
    var.common_tags,
    {
      "Purpose" = "MLOps Platform"
    }
  )
}

# Internet Gateway
resource "oci_core_internet_gateway" "internet_gateway" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.mlops_vcn.id
  display_name   = "mlops-internet-gateway"
  
  defined_tags = var.common_tags
}

# Route Table for Internet Access
resource "oci_core_route_table" "public_route_table" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.mlops_vcn.id
  display_name   = "mlops-public-route-table"

  route_rules {
    network_entity_id = oci_core_internet_gateway.internet_gateway.id
    destination      = "0.0.0.0/0"
    destination_type = "CIDR_BLOCK"
  }
  
  defined_tags = var.common_tags
}

# Service Subnets
resource "oci_core_subnet" "service_subnet" {
  count = 4  # For MLflow, Qdrant, API, and Cache

  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.mlops_vcn.id
  cidr_block     = "10.0.${count.index + 1}.0/24"
  display_name   = var.subnet_names[count.index]
  dns_label      = replace(lower(var.subnet_names[count.index]), "-", "")
  
  security_list_ids = [
    oci_core_security_list.service_security_lists[count.index].id
  ]
  route_table_id    = oci_core_route_table.public_route_table.id
  
  defined_tags = merge(
    var.common_tags,
    {
      "Service" = var.subnet_names[count.index]
    }
  )
}

# Security Lists for each service
resource "oci_core_security_list" "service_security_lists" {
  count = 4

  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.mlops_vcn.id
  display_name   = "${var.subnet_names[count.index]}-security-list"

  # Common ingress rules (SSH)
  ingress_security_rules {
    protocol  = "6" # TCP
    source    = "0.0.0.0/0"
    stateless = false
    tcp_options {
      min = 22
      max = 22
    }
  }

  # Service-specific ingress rules
  dynamic "ingress_security_rules" {
    for_each = var.service_ports[var.subnet_names[count.index]]
    content {
      protocol  = "6" # TCP
      source    = "0.0.0.0/0"
      stateless = false
      tcp_options {
        min = ingress_security_rules.value
        max = ingress_security_rules.value
      }
    }
  }

  # Allow all outbound
  egress_security_rules {
    protocol    = "all"
    destination = "0.0.0.0/0"
    stateless   = false
  }
}

# Load Balancer (Free Tier)
resource "oci_load_balancer" "mlops_lb" {
  compartment_id = var.compartment_id
  display_name   = "mlops-load-balancer"
  shape         = "flexible"
  
  shape_details {
    minimum_bandwidth_in_mbps = 10
    maximum_bandwidth_in_mbps = 10
  }

  subnet_ids = [oci_core_subnet.service_subnet[2].id]  # API subnet
  
  # Reserved IPs - optional, but useful for DNS
  reserved_ips {
    count = 1
  }

  defined_tags = merge(
    var.common_tags,
    {
      "Oracle-Tags.FreeTier" = "true"
    }
  )
}

# Load Balancer Backend Set for MLflow
resource "oci_load_balancer_backend_set" "mlflow_backend" {
  load_balancer_id = oci_load_balancer.mlops_lb.id
  name             = "mlflow-backend"
  policy           = "ROUND_ROBIN"

  health_checker {
    protocol          = "HTTP"
    port              = 5000
    url_path          = "/health"
    interval_ms       = 10000
    timeout_in_millis = 3000
    retries           = 3
  }
}

# Load Balancer Backend Set for API
resource "oci_load_balancer_backend_set" "api_backend" {
  load_balancer_id = oci_load_balancer.mlops_lb.id
  name             = "api-backend"
  policy           = "ROUND_ROBIN"

  health_checker {
    protocol          = "HTTP"
    port              = 8000
    url_path          = "/health"
    interval_ms       = 10000
    timeout_in_millis = 3000
    retries           = 3
  }
}

# Load Balancer Listener for MLflow
resource "oci_load_balancer_listener" "mlflow_listener" {
  load_balancer_id         = oci_load_balancer.mlops_lb.id
  name                     = "mlflow-listener"
  default_backend_set_name = oci_load_balancer_backend_set.mlflow_backend.name
  port                     = 80
  protocol                 = "HTTP"
}

# Load Balancer Listener for API
resource "oci_load_balancer_listener" "api_listener" {
  load_balancer_id         = oci_load_balancer.mlops_lb.id
  name                     = "api-listener"
  default_backend_set_name = oci_load_balancer_backend_set.api_backend.name
  port                     = 8000
  protocol                 = "HTTP"
}

# Network Security Groups
resource "oci_core_network_security_group" "internal_nsg" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.mlops_vcn.id
  display_name   = "mlops-internal-nsg"
  
  defined_tags = var.common_tags
}

# Allow internal service communication
resource "oci_core_network_security_group_security_rule" "internal_rule" {
  network_security_group_id = oci_core_network_security_group.internal_nsg.id
  direction                = "INGRESS"
  protocol                = "all"
  source                  = oci_core_vcn.mlops_vcn.cidr_blocks[0]
  source_type             = "CIDR_BLOCK"
  stateless              = false
}