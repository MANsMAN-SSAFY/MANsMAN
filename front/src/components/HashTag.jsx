import { useState, useEffect } from "react";

export default function HashTag({ content, color }) {
  return (
    <span className={`${color} p-1 rounded-lg mr-2 text-sm`}>{content}</span>
  );
}
