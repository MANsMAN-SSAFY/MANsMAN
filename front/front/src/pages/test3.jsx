import { useState, useEffect } from "react";
import { Link } from "react-router-dom";

export default function test3() {
  return (
    <div>
      <h1>test3</h1>
      <Link to="..">
        <button>뒤로가기</button>
      </Link>
    </div>
  );
}
