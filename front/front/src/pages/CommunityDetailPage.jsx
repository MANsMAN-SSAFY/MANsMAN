import { useState, useEffect } from "react";

import ArticleDetail from "../components/ArticleDetail.jsx";
import CommentCreate from "../components/CommentCreate.jsx";
import CommentList from "../components/CommentList.jsx";

export default function CommunityDetailPage() {
  return (
    <div className="mb-20">
      <ArticleDetail />
      <CommentList />
      <div className="fixed bottom-5 left-1/2 transform -translate-x-1/2 z-10 w-11/12">
        <CommentCreate />
      </div>
    </div>
  );
}
