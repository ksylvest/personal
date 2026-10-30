---
date: "2024-06-06"
title: Prompting ChatGPT to Generate JSON from HTML
summary: Using ChatGPT to Convert HTML to JSON
tags:
  - prompting
  - json
  - html
  - openai
  - chatgpt
canonical_url: https://workflow.ing/blog/articles/prompting-chat-gpt-to-generate-json-from-html
---

OpenAI’s ChatGPT generates text. This is incredibly helpful for human-to-LLM use cases (e.g. chatting with ChatGPT), but can be frustrating when attempting to use ChatGPT for API-to-LLM uses cases (e.g. interfacing with ChatGPT via an API). JSON is a much more convenient format when attempting to extract structured data with an LLM. This article walks through the process to turn an HTML page into structured JSON. This process might be used to build a web scraper. To explore this example, some fake HTML is needed:

```html
<!doctype html>
<html lang="en">
  <head>
    <title>Sizzle and Swine: Tangy Glazed Ribs</title>
  </head>
  <body>
    <h1>Sizzle and Swine: Tangy Glazed Ribs</h1>
    <p>
      Succulent ribs marinated in a tangy blend of sugar, mustard, and spices, then grilled to
      perfection. The glaze caramelizes beautifully, adding a sweet and savory flavor profile to the
      juicy ribs. It's a mouthwatering dish that's sure to impress at your next gathering!
    </p>
    <h2>Ingredients</h2>
    <ul>
      <li>4 pounds ribs</li>
      <li>1/4 cup sugar</li>
      <li>2 tablespoons mustard</li>
      <li>2 cloves garlic</li>
      <li>1 teaspoon paprika</li>
      <li>1/2 teaspoon pepper</li>
      <li>1/2 teaspoon salt</li>
      <li>1 tablespoon oil</li>
    </ul>
    <h2>Steps</h2>
    <ol>
      <li>
        <strong>Prepare the marinade:</strong> In a small bowl, whisk together the sugar, mustard,
        garlic, paprika, pepper, and salt until well combined.
      </li>
      <li>
        <strong>Marinate the pork chops:</strong> Place the pork chops in a shallow dish or
        resealable plastic bag. Pour the marinade over the pork chops, ensuring they are well
        coated. Cover the dish or seal the bag, then refrigerate for at least 30 minutes to allow
        the flavors to meld.
      </li>
      <li>
        <strong>Grill the pork chops:</strong> Preheat your grill to medium heat. Remove the pork
        chops from the marinade and discard any excess marinade. Brush each pork chop lightly with
        olive oil to prevent sticking. Grill the pork chops until cooked through.
      </li>
      <li>
        <strong>Glaze and serve:</strong> During the last few minutes of grilling, brush the pork
        chops with any remaining marinade to create a glossy glaze. Once cooked through, transfer
        the pork chops to a serving platter and let them rest for a few minutes. Garnish with
        chopped fresh parsley, if desired, and serve hot.
      </li>
    </ol>
  </body>
</html>
```

A quick glance indicates that this HTML is for a recipe for "Sizzle and Swine: Tangy Glazed Ribs". The recipe contains a title and description. It also has a list of ingredients with quantity / unit / name. Lastly it offers a list of steps with a name and details. The JSON representation of the HTML is:

```json
{
  "title": "Sizzle and Swine: Tangy Glazed Ribs",
  "description": "Succulent ribs marinated in a tangy blend of sugar, mustard, and spices, then grilled to perfection. The glaze caramelizes beautifully, adding a sweet and savory flavor profile to the juicy ribs. It's a mouthwatering",
  "ingredients": [
    {
      "quantity": "4",
      "unit": "pounds",
      "name": "ribs"
    },
    {
      "quantity": "1/4",
      "unit": "cup",
      "name": "sugar"
    },
    {
      "quantity": "2",
      "unit": "cloves",
      "name": "mustard"
    },
    {
      "quantity": "1",
      "unit": "teaspoon",
      "name": "paprika"
    },
    {
      "quantity": "1/2",
      "unit": "teaspoon",
      "name": "pepper"
    },
    {
      "quantity": "1/2",
      "unit": "teaspoon",
      "name": "salt"
    },
    {
      "quantity": "1",
      "unit": "tablespoon",
      "name": "oil"
    }
  ],
  "steps": [
    {
      "name": "Prepare the marinade",
      "description": "In a small bowl, whisk together the sugar, mustard, garlic, paprika, pepper, and salt until well combined."
    },
    {
      "name": "Marinate the pork chops",
      "description": "Place the pork chops in a shallow dish or resealable plastic bag. Pour the marinade over the pork chops, ensuring they are well coated. Cover the dish or seal the bag, then refrigerate for at least 30 minutes to allow the flavors to meld."
    },
    {
      "name": "Grill the pork chops:",
      "description": "Preheat your grill to medium heat. Remove the pork chops from the marinade and discard any excess marinade. Brush each pork chop lightly with olive oil to prevent sticking. Grill the pork chops until cooked through."
    },
    {
      "name": "Glaze and serve",
      "description": "During the last few minutes of grilling, brush the pork chops with any remaining marinade to create a glossy glaze. Once cooked through, transfer the pork chops to a serving platter and let them rest for a few minutes. Garnish with chopped fresh parsley, if desired, and serve hot."
    }
  ]
}
```

Knowing the format is helpful, but it is not immediately clear what to provide a prompt to ensure it consistently returns data structured using that format each time. Enter [JSON Schema](https://json-schema.org/). JSON Schema allows for the annotation of the structure of JSON. For the above example JSON the schema is:

```json
{
  "title": "Recipe",
  "type": "object",
  "properties": {
    "title": {
      "type": "string"
    },
    "description": {
      "type": "string"
    },
    "ingredients": {
      "type": "array",
      "items": {
        "type": "object",
        "properties": {
          "quantity": {
            "type": "string"
          },
          "unit": {
            "type": "string"
          },
          "name": {
            "type": "string"
          }
        },
        "required": ["quantity", "unit", "name"]
      }
    },
    "steps": {
      "type": "array",
      "items": {
        "type": "object",
        "properties": {
          "name": {
            "type": "string"
          },
          "description": {
            "type": "string"
          }
        },
        "required": ["name", "description"]
      }
    }
  },
  "required": ["title", "description", "ingredients", "steps"]
}
```

Generating that JSON can be done automatically using [transform.tools](https://transform.tools/json-to-json-schema). Just provide a clear example of the desired JSON and annotate any names or descriptions needed. With the schema and HTML constructing a prompt for Open-AI works as follows:

```text
You are an expert at converting HTML to JSON:

1. Respond with only JSON without using markdown code blocks.
2. Ensure it adhears to the attached SCHEMA.

Convert the following HTML with the following SCHEMA:

SCHEMA: ...schema...

HTML: ...html...
```

This prompt can be tested using OpenAI’s [ChatGPT interface](https://chatgpt.com). Using the API equally simple. This Python code handles with ease:

```python
import json
from openai import OpenAI
client = OpenAI()

SCHEMA = {
  "title": "Recipe",
  "type": "object",
  "properties": {
    "title": {
      "type": "string"
    },
    "description": {
      "type": "string"
    },
    "ingredients": {
      "type": "array",
      "items": {
        "type": "object",
        "properties": {
          "quantity": {
            "type": "string"
          },
          "unit": {
            "type": "string"
          },
          "name": {
            "type": "string"
          }
        },
        "required": ["quantity", "unit", "name"]
      }
    },
    "steps": {
      "type": "array",
      "items": {
        "type": "object",
        "properties": {
          "name": {
            "type": "string"
          },
          "description": {
            "type": "string"
          }
        },
        "required": ["name", "description"]
      }
    }
  },
  "required": ["title", "description", "ingredients", "steps"]
}

HTML = """
  <!doctype html>
  <html lang="en">
    <head>
      <title>Sizzle and Swine: Tangy Glazed Ribs</title>
    </head>
    <body>
      <h1>Sizzle and Swine: Tangy Glazed Ribs</h1>
      <p>
        Succulent ribs marinated in a tangy blend of sugar, mustard, and spices,
        then grilled to perfection. The glaze caramelizes beautifully, adding a
        sweet and savory flavor profile to the juicy ribs. It's a mouthwatering
        dish that's sure to impress at your next gathering!
      </p>
      <h2>Ingredients</h2>
      <ul>
        <li>4 pounds ribs</li>
        <li>1/4 cup sugar</li>
        <li>2 tablespoons mustard</li>
        <li>2 cloves garlic</li>
        <li>1 teaspoon paprika</li>
        <li>1/2 teaspoon pepper</li>
        <li>1/2 teaspoon salt</li>
        <li>1 tablespoon oil</li>
      </ul>
      <h2>Steps</h2>
      <ol>
        <li>
          <strong>Prepare the marinade:</strong> In a small bowl, whisk together
          the sugar, mustard, garlic, paprika, pepper, and salt until well
          combined.
        </li>
        <li>
          <strong>Marinate the pork chops:</strong> Place the pork chops in a
          shallow dish or resealable plastic bag. Pour the marinade over the pork
          chops, ensuring they are well coated. Cover the dish or seal the bag,
          then refrigerate for at least 30 minutes to allow the flavors to meld.
        </li>
        <li>
          <strong>Grill the pork chops:</strong> Preheat your grill to medium
          heat. Remove the pork chops from the marinade and discard any excess
          marinade. Brush each pork chop lightly with olive oil to prevent
          sticking. Grill the pork chops until cooked through.
        </li>
        <li>
          <strong>Glaze and serve:</strong> During the last few minutes of
          grilling, brush the pork chops with any remaining marinade to create a
          glossy glaze. Once cooked through, transfer the pork chops to a serving
          platter and let them rest for a few minutes. Garnish with chopped fresh
          parsley, if desired, and serve hot.
        </li>
      </ol>
    </body>
  </html>
"""

SYSTEM_MESSAGE = """
  You are an expert at converting HTML to JSON:

  1. Respond with only JSON without using markdown code blocks.
  2. Ensure it adhears to the attached schema.
"""

USER_MESSAGE = f"""
  Convert the following HTML with the following SCHEMA:

  SCHEMA: {json.dumps(SCHEMA)}

  HTML: {HTML}
"""

response = client.chat.completions.create(
  model="gpt-4o",
  messages=[
    {"role": "system", "content": SYSTEM_MESSAGE},
    {"role": "user", "content": USER_MESSAGE},
  ],
  response_format={"type": "json_object"}
)

content = response.choices[0].message.content
data = json.loads(content)

print(data)
```

Voilà! The result is properly formatted JSON as expected ready for use elsewhere. To go a step further, it is also possible to verify that ChatGPT returned back JSON conforming to the schema with using the [jsonschema](https://github.com/python-jsonschema/jsonschema) package:

```python
# https://github.com/python-jsonschema/jsonschema
from jsonschema import validate

validate(instance=data, schema=SCHEMA)
```

_This article originally appeared on [https://workflow.ing/blog/articles/prompting-chat-gpt-to-generate-json-from-html](https://workflow.ing/blog/articles/prompting-chat-gpt-to-generate-json-from-html)._
