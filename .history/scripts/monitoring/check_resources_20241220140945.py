import argparse
import sys

def check_resources(max_ocpus, max_memory_gb, max_instances):
    # Placeholder for actual OCI API calls
    current_ocpus = 1
    current_memory = 6
    current_instances = 4

    if current_ocpus > max_ocpus or current_memory > max_memory_gb or current_instances > max_instances:
        print(f"Resource usage exceeds limits! OCPUs: {current_ocpus}, Memory: {current_memory} GB, Instances: {current_instances}")
        return 1

    print("Resource usage is within limits.")
    return 0

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--max-ocpus", type=int, required=True)
    parser.add_argument("--max-memory-gb", type=int, required=True)
    parser.add_argument("--max-instances", type=int, required=True)
    args = parser.parse_args()

    sys.exit(check_resources(args.max_ocpus, args.max_memory_gb, args.max_instances))