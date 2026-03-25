Volume 1
<img width="561" height="432" alt="image" src="https://github.com/user-attachments/assets/8484da68-6522-4637-95f8-00ad5110aad2" />

with all the gland options (all able to adjust to size
<img width="581" height="420" alt="image" src="https://github.com/user-attachments/assets/525b5a91-5795-49bc-aff4-acae1f4c489d" />

![5917965004449713343](https://github.com/user-attachments/assets/ae0b18ce-5f44-47c4-b6ca-f3f51ed4c7c2)



# Parametric IP65 Electrobox

A high-quality, **3D-printable**, and **water-resistant** enclosure designed in OpenSCAD. This design is engineered for protecting electronics in demanding environments, featuring a specialized internal sealing mechanism and optimized structural geometry.

---

## ✨ Key Features

* [cite_start]**Parametric Versatility**: All dimensions including length, width, height, and wall thickness are fully adjustable via parameters[cite: 10, 11, 12].
* **IP65 Sealing Design**:
    * [cite_start]**Internal Lip (Shoulder)**: The sealing occurs on an internal "shoulder" rather than overlapping the exterior, providing a tighter moisture barrier[cite: 3, 4, 34].
    * [cite_start]**Blind Mounting Holes**: Screw holes in the base are designed as "blind holes," meaning they do not penetrate the outer shell, maintaining watertight integrity[cite: 6, 38].
* [cite_start]**Hugging Pillars (Slalom Walls)**: The internal walls and sealing rim curve fluidly around the circular screw posts to maximize internal space and structural strength[cite: 5, 32, 33].
* [cite_start]**Configurable Cable Glands**: Built-in support for multiple cable entries on both the X and Y axes with adjustable diameters[cite: 13, 16, 23].
* [cite_start]**Print-Ready Tolerances**: Includes a dedicated `fit_tolerance` parameter to ensure a perfect fit between the lid and the box regardless of printer calibration[cite: 7, 25].

---

## ⚙️ Technical Parameters

| Parameter | Description | Default Value |
| :--- | :--- | :--- |
| `L` | [cite_start]Outer length of the box [cite: 10] | 100 mm |
| `W` | [cite_start]Outer width of the box [cite: 10] | 85 mm |
| `H_box` | [cite_start]Height of the bottom enclosure [cite: 11] | 45 mm |
| `wall` | [cite_start]Outer wall thickness [cite: 12] | 4 mm |
| `lip_h` | [cite_start]Height of the interlocking internal lip [cite: 24] | 2 mm |
| `fit_tolerance` | [cite_start]Clearance gap between lid and box [cite: 25] | 0.2 mm |
| `post_R` | [cite_start]Radius of the internal screw pillars [cite: 26] | 6 mm |

---

## 🚀 How to Use

1.  **Install OpenSCAD**: Ensure you have [OpenSCAD](https://openscad.org/) installed.
2.  **Open the File**: Load `junction_boxV2.scad`.
3.  [cite_start]**Customize**: Use the **Customizer** panel in OpenSCAD to adjust the dimensions and toggle cable glands[cite: 8, 9, 13, 16].
4.  **Export for Printing**:
    * [cite_start]Set `show_box = true` and `show_lid = false` to render and export the base[cite: 8].
    * [cite_start]Set `show_box = false` and `show_lid = true` to render and export the lid[cite: 9].
5.  **Print Settings**: For maximum durability and water resistance, materials like **PETG**, **ASA**, or **ABS** are recommended.

---

## 🛠 Internal Geometry

[cite_start]The box uses a specialized `cavity_profile()` module[cite: 33]. [cite_start]Unlike standard boxes with rectangular interiors, this design uses `offset()` functions to "slalom" around the screw posts, ensuring a smooth, continuous path for the internal seal[cite: 33, 34].

---

*Project generated for high-fidelity 3D printing applications.*
