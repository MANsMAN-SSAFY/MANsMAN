import { useState, useEffect } from "react";
import { Link } from "react-router-dom";

export default function ProfilePage() {
  return (
    <>
      <h1>프로필 페이지</h1>
      <Link to="myarticles">내가쓴 글</Link>
      <Link to="scrap">스크랩 글</Link>
    </>
  );
}
