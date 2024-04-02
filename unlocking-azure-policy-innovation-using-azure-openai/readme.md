# Unlocking Azure Policy innovation using Azure OpenAI

This script is designed to automate the creation of custom Azure Policy definitions using simple prompting and Azure OpenAI. It reads policy prompts from a CSV file and generates policy definitions in JSON format.

You can find more detail and deeper insights in my blog post: [marcogerber.ch | Unlocking Azure Policy innovation using Azure OpenAI](https://marcogerber.ch/unlocking-azure-policy-innovation-using-azure-openai)

## Dependencies

- An Azure subscription
- An Azure OpenAI Service with a model deployed (any GPT-3.5 or GPT-4 will do)
- Python 3.7+ installed on the platform from where you run the script
- `dotenv` for loading environment variables from a `.env` file
- `csv` for reading CSV files
- `json` for parsing and generating JSON data
- `openai` for interacting with the Azure OpenAI service

## Setup

1. Create and active a Python virtual environment

    ```shell
    python3 -m venv .venv
    .venv\scripts\activate
   ```

2. Install the required Python dependencies:

   ```shell
   pip install python-dotenv openai
   ```

3. Create a `.env` file in the root directory with the following variables:

   ```plaintext
   AZURE_OAI_ENDPOINT=<your-azure-openai-endpoint>
   AZURE_OAI_KEY=<your-azure-openai-key>
   AZURE_OAI_DEPLOYMENT=<your-azure-openai-deployment>
   ```

4. Review and adjust the prompts in the `azure-policy-prompts.csv` file

## Usage

Run the script from the command line:

```shell
python azure_policy_generator.py
```

The script will:

- Load configuration settings from the `.env` file
- Create an Azure OpenAI client instance
- Read prompts from the `azure-policy-prompts.csv` file
- Generate policy definitions for each row in the CSV
- Save the policy definitions to the `output` directory

## Functions

### main()

This is the entry point of the script, which orchestrates the policy generation process.

### generate_policy(category, prompt, model, client)

Generates a policy definition based on the given `category` and `prompt`. It uses the specified `model` and `client` to interact with the Azure OpenAI service.

## Output

The generated policy definitions are saved to the `output` directory with file names based on the display name of the policy.

## Error Handling

Any exceptions during the execution of the script are caught and printed to the console.

## Notes

- The script assumes that the Azure OpenAI service is correctly configured and available
- During the development of the script, response formats and sections changed from time to time, you might need to refactor the script to new response formats
- The `generate_policy` function expects a specific prompt structure and may need adjustments for different use cases
- The output directory must exist before running the script
- The system message in the `generate_policy` function is hardcoded and should be modified according to the specific requirements
