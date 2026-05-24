<p align="center">
    <img src="https://i.imgur.com/7eR7Pan.png" width="400"><br>
    Run a biology-focused LLM on your own network.<br>
    Distributed inference and fine-tuning powered by Petals.<br>
    <br><br>
    <a href="https://pypi.org/project/petals/"><img src="https://img.shields.io/pypi/v/petals.svg?color=green"></a>
    <a href="https://discord.gg/tfHfe8B34k"><img src="https://img.shields.io/discord/865254854262652969?label=discord&logo=discord&logoColor=white"></a>
    <br>
</p>

## Biology Model (OpenBioLLM)

BioPetals is a specialized fork of Petals for [aaditya/Llama3-OpenBioLLM-8B](https://huggingface.co/aaditya/Llama3-OpenBioLLM-8B), a biology-oriented LLM built on the Llama 3 architecture. Run it distributed across your own network for fast inference and fine-tuning.

```python
from petals.client import load_biology_model

tokenizer, model = load_biology_model()
inputs = tokenizer("Summarize the role of ribosomes in translation", return_tensors="pt")["input_ids"]
outputs = model.generate(inputs, max_new_tokens=80)
print(tokenizer.decode(outputs[0], skip_special_tokens=True))
```

Run the bundled example script:

```bash
python examples/run_biology_inference.py
```

Run the Colab notebook from this fork:

[Open in Colab](https://colab.research.google.com/github/Pranesh950/BioPetals/blob/main/examples/run_biology_inference_colab.ipynb)

If you prefer copy-pasting cells into Colab, use `%pip` (not plain `pip`) in the install cell:

```python
%pip -q install -U pip setuptools wheel
%pip -q install --upgrade --force-reinstall --no-cache-dir "numpy==1.26.4" "scipy==1.14.1"
%pip -q install --upgrade --force-reinstall --no-cache-dir "protobuf==5.29.6" "grpcio-tools==1.71.2" "grpcio-status==1.71.2" "jedi>=0.19.2"
%pip -q install --upgrade --no-cache-dir "bitsandbytes==0.41.1" "speedtest-cli==2.1.3" "tensor_parallel==1.0.23" "peft==0.8.2"
%pip -q install --upgrade --no-cache-dir "hivemind==1.1.12" "transformers==4.43.1" "accelerate>=0.27.2" "huggingface-hub>=0.11.1,<1.0.0" "tokenizers>=0.13.3" "sentencepiece>=0.1.99" "packaging>=20.9" "humanfriendly" "async-timeout>=4.0.2" "Dijkstar>=2.6.0" "safetensors>=0.3.1"
%pip -q install --upgrade --no-deps --no-cache-dir "git+https://github.com/Pranesh950/BioPetals.git"
```

After installing packages in Colab, restart the runtime once before running inference cells.

Host this biology checkpoint in Petals:

```bash
python -m petals.cli.run_server aaditya/Llama3-OpenBioLLM-8B
```



### Private biology-only swarm

To run a network that serves only the biology checkpoint, start one or more servers announcing that model and do not connect to the public swarm (use `--new_swarm`). The simplest option is the bundled helper:

```bash
./examples/run_bio_server.sh --num-blocks 8 --port 31337
```

- Minimum peers: 1 — a single server that hosts all blocks will make inference possible.
- Distributed mode: if you split the model across multiple people, you need enough peers to host all model blocks (or fewer peers if each peer hosts multiple blocks). The exact number depends on the model's number of blocks and each peer's GPU memory.

Recommended: start with one server (or three for redundancy), verify inference locally, then invite more peers if you want to distribute serving across multiple machines.

🔏 **Privacy.** BioPetals is designed for private, community-run swarms. Your data stays within your network. Learn more about security [here](https://github.com/bigscience-workshop/petals/wiki/Security,-privacy,-and-AI-safety).

💬 **Questions?** Open an issue or check the [Petals wiki](https://github.com/bigscience-workshop/petals/wiki).

## Host a Server

BioPetals networks are community-run &mdash; help by sharing your GPU capacity to serve the biology model:

**Access:** The OpenBioLLM model is open-access. Run `huggingface-cli login` if you want to save credentials locally.

**Setup:**

```bash
# Linux or macOS
pip install git+https://github.com/Pranesh950/BioPetals.git

# Join a private swarm
./examples/run_bio_server.sh --num-blocks 8 --port 31337
```

Or manually:
```bash
python -m petals.cli.run_server aaditya/Llama3-OpenBioLLM-8B --new_swarm --public_ip <YOUR_IP> --port 31337
```

For **Windows**, AMD GPUs, Docker, or multi-GPU setups, see the [Petals wiki](https://github.com/bigscience-workshop/petals/wiki/Run-Petals-server-on-Windows) for detailed instructions.

<p align="center">
    📚 &nbsp;<b><a href="https://github.com/bigscience-workshop/petals/wiki/FAQ:-Frequently-asked-questions#running-a-server">Learn more</a></b> (how to use multiple GPUs, start the server on boot, etc.)
</p>

🔒 **Security.** Hosting a server does not allow others to run custom code on your computer. Learn more [here](https://github.com/bigscience-workshop/petals/wiki/Security,-privacy,-and-AI-safety).

💬 **Any questions?** Ping us in [our Discord](https://discord.gg/X7DgtxgMhc)!

🏆 **Thank you!** Help maintain the network by hosting blocks. You can optionally specify `--public_name YOUR_NAME` for recognition.

## How does it work?

- You load a small part of the model locally, while peers host the remaining blocks. Inference runs efficiently across the distributed network.
- Use any fine-tuning and sampling methods, access hidden states, and enjoy the flexibility of **PyTorch** and **🤗 Transformers** with distributed execution.

<p align="center">
    <img src="https://i.imgur.com/RTYF3yW.png" width="800">
</p>

<p align="center">
    📜 &nbsp;<b><a href="https://arxiv.org/pdf/2209.01188.pdf">Read paper</a></b>
    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
    📚 &nbsp;<b><a href="https://github.com/bigscience-workshop/petals/wiki/FAQ:-Frequently-asked-questions">See FAQ</a></b>
</p>

## 📚 Resources

**Examples:**
- Inference script: `examples/run_biology_inference.py`
- Colab notebook: `examples/run_biology_inference_colab.ipynb`
- Server helper: `examples/run_bio_server.sh`

**Documentation:**
- [Petals Wiki](https://github.com/bigscience-workshop/petals/wiki) — general Petals setup, troubleshooting, and advanced configurations
- [Security & Privacy](https://github.com/bigscience-workshop/petals/wiki/Security,-privacy,-and-AI-safety) — learn how BioPetals keeps your data safe

### Benchmarks

Please see **Section 3.3** of our [paper](https://arxiv.org/pdf/2209.01188.pdf).

### 🛠️ Contributing

Contributions are welcome! Please see the [Petals FAQ](https://github.com/bigscience-workshop/petals/wiki/FAQ:-Frequently-asked-questions#contributing) for contribution guidelines, or open an issue to report bugs and suggest features.

### 📜 Citations

Alexander Borzunov, Dmitry Baranchuk, Tim Dettmers, Max Ryabinin, Younes Belkada, Artem Chumachenko, Pavel Samygin, and Colin Raffel.
[Petals: Collaborative Inference and Fine-tuning of Large Models.](https://arxiv.org/abs/2209.01188)
_Proceedings of the 61st Annual Meeting of the Association for Computational Linguistics (Volume 3: System Demonstrations)._ 2023.

```bibtex
@inproceedings{borzunov2023petals,
  title = {Petals: Collaborative Inference and Fine-tuning of Large Models},
  author = {Borzunov, Alexander and Baranchuk, Dmitry and Dettmers, Tim and Riabinin, Maksim and Belkada, Younes and Chumachenko, Artem and Samygin, Pavel and Raffel, Colin},
  booktitle = {Proceedings of the 61st Annual Meeting of the Association for Computational Linguistics (Volume 3: System Demonstrations)},
  pages = {558--568},
  year = {2023},
  url = {https://arxiv.org/abs/2209.01188}
}
```

Alexander Borzunov, Max Ryabinin, Artem Chumachenko, Dmitry Baranchuk, Tim Dettmers, Younes Belkada, Pavel Samygin, and Colin Raffel.
[Distributed inference and fine-tuning of large language models over the Internet.](https://arxiv.org/abs/2312.08361)
_Advances in Neural Information Processing Systems_ 36 (2023).

```bibtex
@inproceedings{borzunov2023distributed,
  title = {Distributed inference and fine-tuning of large language models over the {I}nternet},
  author = {Borzunov, Alexander and Ryabinin, Max and Chumachenko, Artem and Baranchuk, Dmitry and Dettmers, Tim and Belkada, Younes and Samygin, Pavel and Raffel, Colin},
  booktitle = {Advances in Neural Information Processing Systems},
  volume = {36},
  pages = {12312--12331},
  year = {2023},
  url = {https://arxiv.org/abs/2312.08361}
}
```

--------------------------------------------------------------------------------

<p align="center">
    This project is a part of the <a href="https://bigscience.huggingface.co/">BigScience</a> research workshop.
</p>
<p align="center">
    <img src="https://petals.dev/bigscience.png" width="150">
</p>
