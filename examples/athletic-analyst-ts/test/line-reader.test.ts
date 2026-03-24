import test from "node:test";
import assert from "node:assert/strict";
import { PassThrough, Writable } from "node:stream";
import { PromptReader } from "../src/line-reader.js";

test("PromptReader consumes multiple piped lines in order", async () => {
  const input = new PassThrough();
  const output = new Writable({
    write(_chunk, _encoding, callback) {
      callback();
    },
  });

  input.end("sunset\n202012\n");

  const reader = new PromptReader(input, output);
  const word = await reader.question("Word: ");
  const code = await reader.question("PIN: ");
  reader.close();

  assert.equal(word, "sunset");
  assert.equal(code, "202012");
});
