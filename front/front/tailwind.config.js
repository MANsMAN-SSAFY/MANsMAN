/** @type {import('tailwindcss').Config} */

export default {
  content: [
    './index.html',
    './src/**/*.{js,ts,jsx,tsx}',
  ],
  theme: {
    extend: {},
  },
  plugins: [
    function ({ addUtilities }) {
      const newUtilities = {
        '.container-center': {
          marginLeft: 'auto',
          marginRight: 'auto',
          maxWidth: '90%', // 100% - (5% + 5%)
        },
      };

      addUtilities(newUtilities, ['responsive', 'hover']);
    },
  ],
}