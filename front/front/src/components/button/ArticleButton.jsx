import { useState, useEffect } from "react";

export default function ArticleButton({ icon, title, color }) {
  return (
    <>
      <button
        type="button"
        className={`text-white ${color.default} ${color.hover} px-2 py-1 rounded-md`}
      >
        {title}
      </button>
    </>
  );
}
