import create from "zustand";

const useUserStore = create((set) => ({
  token: "123123",
  setToken: (item) => set({ token: item }),
}));

export default useUserStore;
