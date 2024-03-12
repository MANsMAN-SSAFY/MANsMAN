import { useState, useEffect } from "react";
import { Link } from "react-router-dom";

export default function test4() {
  return (
    <>
      <h1>test4</h1>
      <Link to="..">
        <button>뒤로가기</button>
      </Link>
    </>
  );
}
