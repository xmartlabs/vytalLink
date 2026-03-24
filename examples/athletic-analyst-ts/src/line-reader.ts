// PromptReader wraps readline to support both interactive TTY and piped stdin (used in integration tests).
import * as readline from "node:readline";
import type { Readable, Writable } from "node:stream";

export class PromptReader {
  private readonly rl: readline.Interface | null;
  private readonly preloadPromise: Promise<void> | null;
  private readonly lines: string[] = [];
  private preloadError: Error | null = null;

  constructor(private readonly input: Readable, private readonly output: Writable) {
    if ("isTTY" in input && input.isTTY) {
      this.rl = readline.createInterface({ input, output });
      this.preloadPromise = null;
    } else {
      this.rl = null;
      this.preloadPromise = this.preloadInput();
    }
  }

  question(prompt: string): Promise<string> {
    if (this.rl) {
      return new Promise((resolve, reject) => {
        this.rl!.question(prompt, (answer) => resolve(answer.trim()));
        this.rl!.once("error", reject);
      });
    }

    return this.readBufferedLine(prompt);
  }

  close(): void {
    this.rl?.close();
  }

  private async readBufferedLine(prompt: string): Promise<string> {
    this.output.write(prompt);
    await this.preloadPromise;
    if (this.preloadError) {
      throw this.preloadError;
    }
    return (this.lines.shift() ?? "").trim();
  }

  private preloadInput(): Promise<void> {
    return new Promise((resolve, reject) => {
      let data = "";
      this.input.setEncoding("utf8");
      this.input.on("data", (chunk: string) => {
        data += chunk;
      });
      this.input.on("end", () => {
        this.lines.push(...data.split(/\r?\n/).filter((line, index, all) => !(index === all.length - 1 && line === "")));
        resolve();
      });
      this.input.on("error", (error) => {
        this.preloadError = error instanceof Error ? error : new Error(String(error));
        reject(this.preloadError);
      });
    });
  }
}
