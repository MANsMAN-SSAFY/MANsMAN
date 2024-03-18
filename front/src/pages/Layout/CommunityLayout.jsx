import { useState, useEffect } from "react";
import { Outlet } from "react-router-dom";
import { ScrollRestoration } from "react-router-dom";

export default function CommunityLayout() {
  return (
    <div>
      <ScrollRestoration />
      <Outlet />
    </div>
  );
}
