import { useState, useEffect } from "react";
import styled from "styled-components";

import { Link } from "react-router-dom";

export default function IndexPage() {
  return (
    <>
      <div className="text-center text-4xl">메인페이지</div>
      <nav>
        <Link to="cosmetics">화장품 |</Link>
        <Link to="profile">프로필 |</Link>
        <Link to="community">커뮤니티 |</Link>
        <Link to="record">일지</Link>
      </nav>
    </>
  );
}
