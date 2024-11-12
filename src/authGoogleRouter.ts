import express from "express";
import passport from "passport";
import { Strategy as GoogleStrategy } from "passport-google-oauth20";

passport.use(
  new GoogleStrategy(
    {
      clientID: process.env.GOOGLE_CLIENT || "",
      clientSecret: process.env.GOOGLE_SECRET || "",
      callbackURL: "/oauth2/redirect/google",
    },
    async function findOrAddUser(accessToken, refreshToken, profile, cb) {
      console.log("profile!!", profile, accessToken);
      // const user = await dbModule.findOrAddFederatedUser(profile);
      return cb(null, { username: "userBob" });
    }
  )
);

passport.serializeUser(function (user, cb) {
  process.nextTick(function () {
    cb(null, user);
  });
});

passport.deserializeUser(function (user, cb) {
  process.nextTick(function () {
    return cb(null, { username: "userBob" });
  });
});

export const router = express.Router();

router.get(
  "/auth/google",
  passport.authenticate("google", { scope: ["profile"] })
);

router.get(
  "/oauth2/redirect/google",
  passport.authenticate("google", {
    // successRedirect: "http://localhost:3000",
    failureRedirect: "http://localhost:3000/login",
  }),
  (req, res) => {
    // console.log("🚀 ~ req:", req, res);
    // Successful authentication, redirect home.

    res.redirect("http://localhost:3000/");
    // res.writeHead(302, { Location: "http://localhost:3000" });
  }
);

// router.get("/", (req, res) => {
//   res.redirect("http://localhost:3000");
// });
