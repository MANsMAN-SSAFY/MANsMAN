import { useState, useEffect } from "react";
import { Outlet } from "react-router-dom";

export default function CommunityLayout() {
  return (
    <div>
      <Outlet />
    </div>
  );
}
