import os
import csv, json
from dotenv import load_dotenv
from openai import AzureOpenAI

def main():

    try:

        # Get configuration settings
        load_dotenv()
        azure_oai_endpoint = os.getenv("AZURE_OAI_ENDPOINT")
        azure_oai_key = os.getenv("AZURE_OAI_KEY")
        azure_oai_deployment = os.getenv("AZURE_OAI_DEPLOYMENT")

        # Configure the Azure OpenAI client
        client = AzureOpenAI(
                azure_endpoint = azure_oai_endpoint,
                api_key=azure_oai_key,
                api_version="2023-05-15"
                )

        # Reading Azure Policy definitions
        rows = []
        with open('azure-policy-prompts.csv') as csv_file:
            csv_reader = csv.reader(csv_file, delimiter=';')
            header = next(csv_reader)
            for row in csv_reader:
                generate_policy(row[0], row[1], model=azure_oai_deployment, client=client)

    except Exception as ex:
        print(ex)

def generate_policy(category, prompt, model, client):

    # Generate the user and system prompt
    system_message = "You are a developer specialized in Microsoft Azure. You are specialized in Azure Policy and help create custom policy defentitions. You only respond in json and do not include any explanations."
    user_message = f"{prompt} Choose a matching displayname and description inside the policy definition. Use '{category}' as the category."

    # Format the request message
    messages = [
        {"role": "system", "content": system_message},
        {"role": "user", "content": user_message},
    ]

    # Call the Azure OpenAI model
    response = client.chat.completions.create(
        model=model,
        messages=messages,
        temperature=0.6,
        max_tokens=1000,
        top_p=0.95,
        frequency_penalty=0,
        presence_penalty=0,
        stop=None
    )

    # Remove code formatting
    json_formatted = response.choices[0].message.content.replace("```json", "").replace("```", "")

    # Parse the JSON data to get the display name
    json_definition = json.loads(json_formatted)

    # Extract the file name from the policy definition
    output_file_name = f"{json_definition['properties']['displayName'].replace(' ', '_').lower()}.json"

    # Write the response to a file
    output_file = open(file=f"output/{output_file_name}", mode="w", encoding="utf8")
    output_file.write(json_formatted)
    print(f"Successfully created output/{output_file_name}")

if __name__ == '__main__':
    main()