import js from "@eslint/js";

export default [
  js.configs.all,
  {
    "languageOptions": {
      "parserOptions": {
        "ecmaVersion": 6,
        "sourceType": "module"
      }
    }
  }
];
