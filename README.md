# 🌕 Simulation Lunar Lander

A 3D **Lunar Lander simulation** built in **Godot**, featuring a fully custom physics system — no built-in rigid body dynamics.  
The player controls a lander with realistic thrust and fuel mechanics, aiming to achieve a soft landing on various planets.

---

## 🎮 Gameplay Overview

Pilot the lander using thrust controls to counter gravity and land safely.

**Controls**
| Action | Key |
|---------|-----|
| Ascend / Up Thrust | ↑ / W |
| Descend / Down Thrust | ↓ / S |
| Move Left / Right | A / D |
| Rotate Left / Right | ← / → |
| Reset Camera | Space |

---

## ⚙️ Key Features

- 🚀 **Manual Physics Integration** – velocity, acceleration, and position updated each frame  
- 🪐 **Planetary Variation** – 3 different levels with gravity and thrust parameters tuned for each planet  
- ⛽ **Fuel System** – thrust consumes limited fuel; depletion disables engines  
- 💥 **Collision & Landing Detection** – dual sensor pads detect safe or crash landings  
- 🧭 **Custom Camera Control** – player-controlled rotation and reset function  

---

## 📊 Parameter Settings

| Level | Gravity | Safe Landing Speed | Fuel | Thrust |
|-------|----------|--------------------|------|---------|
| 1 | −1.625 | 20.0 | 100.0 | 15000.0 |
| 2 | −3.711 | 25.0 | 250.0 | 12000.0 |
| 3 | −3.711 | 250.0 | 80.0  | 37000.0 |

---

## 🧩 Documentation

Full technical report detailing the **physics system**, **input design**, and **parameters**:  
📄 [LL-Ernst-Protokoll.pdf](LL-Ernst-Protokoll.pdf)

---

## 🎥 Demo Video

A short video demonstration (2 min) of gameplay, physics behavior, and landing detection.

▶️ [Watch the demo video](LL-Ernst-Video.mkv)

> If GitHub can’t preview `.mkv` directly, download and open locally — or convert to `.mp4` for in-page playback.

---


## 👤 Author

**Fridolin Ernst**  
University of Applied Sciences Technikum Wien  
Department of Computer Science  
Winter Semester 2025/26

---

## 🪪 License
This project is intended for educational and portfolio use only.
