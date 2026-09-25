---
title: ReelAI
emoji: 🎬
colorFrom: blue
colorTo: purple
sdk: docker
app_port: 7860
short_description: Create narrated short videos from a topic or your own script.
license: mit
---

# ReelAI

An English, Hugging Face Docker Space edition of [MoneyPrinterTurbo](https://github.com/harry0703/MoneyPrinterTurbo). Enter a topic or write a script, choose stock footage or an AI video provider, add narration, music, and subtitles, and download the resulting MP4. The original MIT license and attribution are retained in [LICENSE](LICENSE).

## Deploy from this GitHub repository

Initial setup (once):

1. Get a [Hugging Face token](https://huggingface.co/settings/tokens) with permission to create/write a Space in your account. Set two **GitHub repository secrets** at **Settings → Secrets and variables → Actions**: `HF_TOKEN` (the token) and `REELAI_PASSWORD` (a strong password you choose for your Space).
2. Open [Deploy to Hugging Face Spaces](https://github.com/ArnavSingh76533/reelai/actions/workflows/deploy-space.yml), click **Run workflow**, and enter your Space ID as `your-hf-username/reelai`. The action creates or updates the Docker Space, installs the password as a Space secret, and uploads this repository. Later redeployments take the same one click.
3. Open `https://huggingface.co/spaces/your-hf-username/reelai`, enter your password, and configure your providers in **Settings**. The build can take several minutes.

If you prefer to upload files yourself, create a new [Docker Space](https://huggingface.co/new-space) and push this repository's files to its Git remote. Set `REELAI_PASSWORD` under that Space's **Settings → Variables and secrets** before using it. The README metadata sets Docker and port 7860 automatically.

## Make your first video

1. In **Settings → LLM**, select a supported provider, enter its API key and model, and test the connection. You can also write the script yourself without an LLM key.
2. In **Settings → Video Materials**, add a Pexels, Pixabay, or Coverr key for stock clips; alternatively configure a supported paid AI video provider. You can upload local footage instead. Hugging Face hosts the editing app; it does not automatically provide free video generation or provider credits.
3. Enter a subject, choose **English (en-US)**, generate or paste the script, select a material source, and choose narration (Edge TTS, another configured provider, uploaded audio, or no voice). Then click **Generate Video** and download the MP4.

Keep the Space password private. Anyone with access to the unlocked app can use configured API keys and view its generated files. Provider calls may incur charges. The Space's ordinary filesystem is temporary across restarts, so download completed videos; for permanent storage, attach a Hugging Face storage volume and adapt the app's `storage/` path.

## Run locally with Docker

```bash
docker build -t reelai .
docker run --rm -p 7860:7860 -e REELAI_PASSWORD=change-this-password reelai
```

Visit `http://localhost:7860`. For local persistence, mount a writable directory at `/app/storage` and mount a writable `config.toml` at `/app/config.toml` after copying `config.example.toml`. Do not commit either file: settings can contain credentials.

## Notes

- CPU Spaces can compose stock footage and perform narration/subtitles, but long videos and local Whisper transcription may be slow. Cloud AI video providers require their own keys and credit.
- Docker runs as user ID 1000 and installs FFmpeg. Only the Streamlit UI is exposed on port 7860; the upstream FastAPI entry point is not started.
- The only bundled UI locale is English. The original source contains integrations and internal model identifiers from several regions; provider availability depends on your own account and location.
