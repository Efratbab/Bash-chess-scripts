# 🖥️ Bash Chess Scripts

Bash scripts for splitting and simulating chess PGN games.  
This project demonstrates **Bash scripting, file parsing, error handling, and CLI interactivity** by working with **Portable Game Notation (PGN)** files, the standard format for chess games.  

---

## 📂 Project Contents

- **`split_pgn.sh`** – Splits a PGN file containing multiple chess games into separate files.  
- **`chess_sim.sh`** – Simulates a chess game in the terminal using PGN input, with interactive navigation.  
- **`parse_moves.py`** – Helper Python script that converts PGN moves into **UCI** (Universal Chess Interface) format.  
- **`capmemel24.pgn`** – Example PGN file for testing.  
- **`splited_pgn/`** – Example output folder with split PGN files (created automatically when you run the script).  

---

## ⚡ Quick Start

1. **Clone the repository**
   ```bash
   git clone https://github.com/<your-username>/bash-chess-scripts.git
   cd bash-chess-scripts
2. **Make scripts executable**
    ```bash
   chmod +x split_pgn.sh
   chmod +x chess_sim.sh
3. **Install Python dependency**
   ```bash
   pip install chess
4. **Run the PGN Splitter**
   ```bash
   ./split_pgn.sh capmemel24.pgn splited_pgn
5. **Run the Chess Simulator**
   ```bash
   ./chess_sim.sh splited_pgn/capmemel24_1.pgn
