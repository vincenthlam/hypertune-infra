import json
import argparse

def aggregate_results(tfsec_file, checkov_file, output_file):
    results = {
        "tfsec": json.load(open(tfsec_file)),
        "checkov": json.load(open(checkov_file))
    }

    with open(output_file, "w") as outfile:
        json.dump(results, outfile, indent=4)

    print(f"Aggregated results saved to {output_file}")

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--tfsec", required=True, help="Path to TFSec SARIF file")
    parser.add_argument("--checkov", required=True, help="Path to Checkov SARIF file")
    parser.add_argument("--output", required=True, help="Path to save aggregated results")
    args = parser.parse_args()

    aggregate_results(args.tfsec, args.checkov, args.output)