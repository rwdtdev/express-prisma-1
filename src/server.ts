import express, { Express } from "express";
import { router as indexRouter } from "./router";
import cors from "cors";
import { router as authRouter } from "./authGoogleRouter";
import session from "express-session";
import passport from "passport";
import { PrismaClient } from "@prisma/client";
import { PrismaSessionStore } from "@quixo3/prisma-session-store";
import cookieParser from "cookie-parser";

const port = 3005;
const app: Express = express();
app.use(cors({ credentials: true, origin: "http://localhost:3000" }));
app.use(cookieParser());
app.use(
  session({
    secret: "keyboard cat",
    resave: false,
    saveUninitialized: false,
    cookie: { secure: false },
    store: new PrismaSessionStore(new PrismaClient(), {
      checkPeriod: 2 * 60 * 1000, //ms
      dbRecordIdIsSessionId: true,
      dbRecordIdFunction: undefined,
    }),
  })
);
// app.use(passport.initialize());
// app.use(passport.session());
app.use(passport.authenticate("session"));
app.use(indexRouter);
app.use(authRouter);

app.listen(port, () => {
  console.log("server listen port", port);
});
