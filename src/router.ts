import express from "express";
import { PrismaClient } from "@prisma/client";
import passport from "passport";

export const router = express.Router();
const prisma = new PrismaClient();

router.get("/getevents", async (req, res) => {
  console.log("get /getevents", req.session, req.sessionID);
  console.dir(req.cookies, { depth: 5 });
  const prismaRes = await prisma.event.findMany({});
  res.json(prismaRes);
});

router.get("/getusers", async (_, res) => {
  console.log("get /users");
  const prismaRes = await prisma.user.findMany({});
  console.log("🚀 ~ router.get ~ prismaRes:", prismaRes);
  res.json(prismaRes);
});

router.get("/getinventoryobjects", async (_, res) => {
  console.log("get /getinventoryobjects");
  const prismaRes = await prisma.inventoryObject.findMany({});
  console.log("🚀 ~ router.get ~ prismaRes:", prismaRes);
  res.json(prismaRes);
});

router.get("/getuser", async (req, res) => {
  console.log(
    "🚀 ~ router.getsession ~ req:",
    { 1: req.cookies },
    { 2: req.session },
    { 3: req.session?.passport?.user },
    { 4: req.sessionID }
  );
  res.json(req.session?.passport?.user);
  // const prismaRes = await prisma.session.findUnique({})
});
