Create a Fast API based on kite.connect. It should have all the functions required starting from login, logout, getting refresh token etc.Refer for documentation:https://www.kite.trade/docs/connect/v3/
Think like Claude Sonnet AI Code generator  and provide output same as Claude Sonnet 4.1
Create a new tasks.md file and add all the tasks to it and mark the tasks as completed once it is implemented.
UI Tech Stack:React with typescript.UI Features:
1. create frontend with login screen similar to kite.zerodha. and it should automate rest of the login process.2. Integrate the APIs with Frontend.
3. Once Login process is complete, Add a screen to get the hostorical data, provide the instrument name and the path to save the data locally.4. I will provide rest of the functionality as we proceed. 5. Add swagger to backend6. Implement all the API of kite.7. After successful login page, Front end should have a dashboard and left menu, with multiple options which will be implemented in future.8. To start with Load the holdings and display it in the Holdings page. Check the reponse of holdings and design the UI accordinlgy.9. Get the instruments data from Zeodha via api and save them in a file and use it across the portal when required.10. Implement functionality to download the historical data of the stocks. It should provide Ui to select start date end date and timeframe and location to store the data.11. It should also have the option to download buld stock data.12. It should also have the option to download stock, options, futures data13. Also add a screen to display the chart similar to Kite.zerodha.com

Folder Structure:frontend - This is for Frontendbackend - this is for python APIs



Create a sctiprt which will start both backend and frontend
UI look and Feel:
# Stunning Website UI Design Instructions for AI Code Generator
Use the following UI-focused principles and instructions to generate visually beautiful, modern websites using an AI code generator. Prioritize visual clarity, layout balance, and aesthetic appeal across devices.
---
## 1. Layout & Structure- Use a **12-column responsive grid system** with 20px gutters.- Apply consistent **spacing and padding** (e.g., 16px–24px scale) to create separation between content blocks.- Structure HTML layout using semantic containers: `<header>`, `<main>`, `<section>`, `<footer>`.
---
## 2. Typography- Use **modern sans-serif fonts** (e.g., Inter, Roboto, Open Sans).- Apply heading hierarchy with proper scaling:  - `h1`: 2.25rem  - `h2`: 1.75rem  - `p`: 1rem- Set **line height** to ~1.5 for readability.- Limit body text width to 60–75 characters (`max-width: 35em`).
---
## 3. Color & Visual Hierarchy- Use a **limited color palette**: primary, secondary, accent, background, and text.- Maintain **high contrast** (WCAG ≥ 4.5:1) between text and background.- Highlight important elements (e.g., buttons, links) with color and size emphasis.- Keep background neutral and text dark for readability.
---
## 4. Grid-Based Design- Align content using **12-column grid** with even margins and gutters.- Place main content in 8 columns and sidebar in 4 (desktop view).- Snap all elements (images, text blocks, cards) to grid for consistency.
---
## 5. Responsive Design- Use **media queries** for breakpoints at 1200px, 768px, and 480px.- Convert multi-column layouts to single-column on mobile.- Adjust typography, spacing, and button size on smaller screens.
---
## 6. Buttons & Interactives (Visual Only)- Style buttons with distinct shapes, hover states, and shadow or outline effects.- Use **rounded corners** (e.g., 8px–12px), consistent padding (e.g., 12px vertical, 24px horizontal).- Maintain visual distinction between primary, secondary, and disabled buttons.
---
## 7. Content Blocks & Cards- Display grouped content in **elevated cards** (use subtle shadows).- Add **consistent spacing** between cards (e.g., 24px) and padding inside (e.g., 16px).- Keep card design clean with clear headings, icons, and brief text.
---
## 8. Imagery & Icons- Use high-quality, optimized images with aspect ratio control.- Align images with text using consistent padding and border radius.- Use meaningful icons (preferably SVGs) for visual communication next to headers or CTA elements.
---
## 9. Aesthetic Enhancements- Add **subtle transitions** (e.g., fade-in, slide-up, scale) to UI elements.- Avoid animation overload; use **microinteractions** only for visual delight (hover, focus).- Use shadows and gradients sparingly to enhance depth and emphasis.
---
## 10. Clean, Minimal UI- Avoid unnecessary decorative elements.- Use a max of **2 font families** and **5 colors**.- Keep alignment, padding, and spacing consistent across all elements.
---
Use these instructions to ensure your AI-generated website delivers a clean, modern, and beautiful visual experience that works flawlessly across devices.