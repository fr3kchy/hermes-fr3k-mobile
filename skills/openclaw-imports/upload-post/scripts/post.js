#!/usr/bin/env node

import fs from "node:fs";
import path from "node:path";
import process from "node:process";

const API_BASE = "https://api.upload-post.com/api";
const IMAGE_EXTS = new Set([".jpg", ".jpeg", ".png", ".gif", ".webp"]);
const VIDEO_EXTS = new Set([".mp4", ".mov", ".webm", ".m4v", ".avi"]);

function parseArgs(argv) {
  const parsed = {};
  for (let i = 0; i < argv.length; i += 1) {
    const token = argv[i];
    if (!token.startsWith("--")) continue;
    const key = token.slice(2);
    const next = argv[i + 1];
    if (!next || next.startsWith("--")) {
      parsed[key] = true;
      continue;
    }
    parsed[key] = next;
    i += 1;
  }
  return parsed;
}

function usage() {
  console.error(
    "Usage: post.js --platform PLATFORM --caption TEXT [--media file1,file2] " +
      "[--schedule ISO8601] [--timezone IANA] [--first-comment TEXT]",
  );
}

function detectMediaKind(files) {
  if (!files.length) return "text";
  const exts = files.map((file) => path.extname(file).toLowerCase());
  if (exts.every((ext) => IMAGE_EXTS.has(ext))) return "photo";
  if (exts.every((ext) => VIDEO_EXTS.has(ext))) return "video";
  throw new Error(`Mixed or unsupported media extensions: ${exts.join(", ")}`);
}

async function addFiles(form, fieldName, files) {
  for (const filePath of files) {
    const absolutePath = path.resolve(filePath);
    const buffer = await fs.promises.readFile(absolutePath);
    const blob = new Blob([buffer]);
    form.append(fieldName, blob, path.basename(absolutePath));
  }
}

async function main() {
  const args = parseArgs(process.argv.slice(2));
  const platform = args.platform;
  const caption = args.caption || args.title;
  const apiKey = process.env.UPLOAD_POST_API_KEY;
  const profile = process.env.UPLOAD_POST_PROFILE || process.env.UPLOAD_POST_USER;

  if (!platform || !caption) {
    usage();
    process.exit(1);
  }
  if (!apiKey || !profile) {
    console.error("Missing UPLOAD_POST_API_KEY or UPLOAD_POST_PROFILE/UPLOAD_POST_USER");
    process.exit(2);
  }

  const files = typeof args.media === "string"
    ? args.media.split(",").map((part) => part.trim()).filter(Boolean)
    : [];
  const kind = detectMediaKind(files);

  let url = `${API_BASE}/upload_text`;
  let body;
  const headers = { Authorization: `Apikey ${apiKey}` };

  if (kind === "text") {
    headers["Content-Type"] = "application/json";
    body = JSON.stringify({
      user: profile,
      platform: [platform],
      title: caption,
      scheduled_date: args.schedule || undefined,
      timezone: args.timezone || undefined,
      first_comment: args["first-comment"] || undefined,
    });
  } else {
    const form = new FormData();
    form.append("user", profile);
    form.append("platform[]", platform);
    form.append("title", caption);
    if (args.schedule) form.append("scheduled_date", args.schedule);
    if (args.timezone) form.append("timezone", args.timezone);
    if (args["first-comment"]) form.append("first_comment", args["first-comment"]);

    if (kind === "photo") {
      url = `${API_BASE}/upload_photos`;
      await addFiles(form, "photos[]", files);
    } else {
      url = `${API_BASE}/upload_videos`;
      await addFiles(form, "video", files.slice(0, 1));
    }

    body = form;
  }

  const response = await fetch(url, { method: "POST", headers, body });
  const text = await response.text();
  if (!response.ok) {
    console.error(text);
    process.exit(3);
  }
  console.log(text);
}

main().catch((error) => {
  console.error(error instanceof Error ? error.message : String(error));
  process.exit(4);
});
