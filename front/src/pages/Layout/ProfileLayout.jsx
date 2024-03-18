import { useState, useEffect } from "react";
import { Outlet } from "react-router-dom";
import { ScrollRestoration } from "react-router-dom";

export default function ProfileLayout() {
  return (
    <div>
      <ScrollRestoration />
      <Outlet />
    </div>
  );
}
