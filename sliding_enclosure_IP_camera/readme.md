# Parametric Enclosure with Sliding Dividers

A fully customizable, 3D-printable enclosure featuring a sliding lid, cable management, and modular internal dividers. Designed in **OpenSCAD** for maximum flexibility and precision.

<img width="595" height="439" alt="Schermafbeelding 2026-02-20 123832" src="https://github.com/user-attachments/assets/c6d1fc9d-da28-4fcc-9788-d7399ec5ea12" />

## 🛠 Features

* **Fully Parametric:** Easily adjust length, width, height, and wall thickness by changing a few variables.
* **Sliding Lid with Optional Inner Wall:** Includes a `true`/`false` toggle to add or remove an extra internal reinforcement wall attached to the lid.
* **Cable Management:** Pre-configured with a hole for a cable gland (back) and a cable cutout (front).
* **Modular Dividers:** Automatically generates slot-in dividers with custom cable pass-throughs at defined positions.
* **Ergonomic Design:** Integrated finger grips on the sides of the lid for easy opening and closing.

## 🚀 Getting Started

1. **Download OpenSCAD:** If you haven't already, download it at [openscad.org](https://openscad.org/).
2. **Open the Script:** Open the `.scad` file provided in this repository.
3. **Customize:** Adjust the parameters in the "Parameters" section at the top of the code.
4. **Render:** * Press `F5` for a quick preview.
   * Press `F6` to render the final geometry.
5. **Export:** Click the **STL** button to export your file for 3D printing.

## ⚙️ Key Parameters

| Parameter | Description | Default Value |
| :--- | :--- | :--- |
| `inner_length` | Internal length of the box | 150 mm |
| `inner_width` | Internal width of the box | 26.5 mm |
| `wall_thickness` | Thickness of the external walls | 3 mm |
| `include_extra_wall` | **True/False**: Toggle the extra inner wall and its groove | `true` |
| `gland_hole_diameter` | Diameter for the cable gland (back) | 20.3 mm |
| `pos_divider_1` to `4` | Custom positions for the sliding dividers | Variable |

### The Extra Inner Wall
The `include_extra_wall` parameter is a specialized feature. When set to `true`, a vertical wall is added to the lid that slides into a matching groove in the base. This is useful for:
* Adding structural rigidity.
* Creating a physical barrier near the cable entry points.
* Locking the lid more securely.

## 📦 Model Selection

The script allows you to render parts individually or together using the toggle switches at the bottom of the parameter list:

* `print_base = true;` — Renders the main enclosure.
* `print_lid = true;` — Renders the sliding lid.
* `print_dividers = true;` — Renders a set of dividers (standard and spare).

## 📄 License

This project is released under the **MIT License**. Feel free to modify, distribute, and use it for your own projects.
