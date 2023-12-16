const bcrypt = require('bcrypt');

const User = require('../models/userSchema');
const jwt = require('jsonwebtoken');
const mongoose = require('mongoose');
const express = require('express');
const app = express();

// Middleware to parse JSON bodies
app.use(express.json());

const cloudinary = require('cloudinary');

cloudinary.v2.config({
  cloud_name: 'your_cloud_name',
  api_key: 'your_api_key',
  api_secret: 'your_api_secret',
  secure: true,
});

exports.signUp = async (req, res) => {
  try {
    const { userName, fullName, email, password } = req.body;
    const profilePicFile = req.files && req.files.file;

    if (!profilePicFile) {
      return res.status(400).json({
        success: false,
        message: 'Profile picture not provided',
      });
    }

    const cloudinaryResponse = await cloudinary.uploader.upload(profilePicFile.tempFilePath, {
      resource_type: "auto",
      public_id: `${Date.now()}`,
    });

    const existingUser = await User.findOne({ email });
    const exitingUserName = await User.findOne({ userName });
    
    if (exitingUserName) {
      return res.status(400).json({
        success: false,
        message: 'User Name already exists',
      });
    }

    if (existingUser) {
      return res.status(400).json({
        success: false,
        message: 'Email already in use',
      });
    }

    const hashedPassword = await bcrypt.hash(password, 10);

    const user = await User.create({
      userName,
      fullName,
      email,
      password: hashedPassword,
      profilepic: cloudinaryResponse.secure_url,
    });

    return res.status(200).json({
      success: true,
      message: 'User created successfully',
    });
  } catch (err) {
    console.error(err);
    return res.status(400).json({
      success: false,
      message: `User cannot be registered. Please try again later.${err}`,
    });
  }
};

exports.login = async (req, res) => {
  try {
    const { email, password } = req.body;
    if (!email || !password) {
      return res.status(400).json({
        success: false,
        message: 'Please fill in the details carefully',
      });
    }

    const user = await User.findOne({ email });
    if (!user) {
      return res.status(401).json({
        success: false,
        message: 'User is not registered',
      });
    }

    if (await bcrypt.compare(password, user.password)) {
      const payload = {
        id: user._id,
        email: user.email,
      };
      const token = jwt.sign(payload, 'Aryan', {
        expiresIn: '2h',
      });

      // Include user information in the response
      const userInfo = {
        _id: user._id,
        userName: user.userName,
        email: user.email,
        profilepic: user.profilepic,
        bio: user.bio,
      };

      return res.status(200).json({
        success: true,
        token,
        user: userInfo,
        message: 'User logged in successfully',
      });
    } else {
      return res.status(403).json({
        success: false,
        message: 'Password does not match',
      });
    }
  } catch (err) {
    console.log(err);
    return res.status(500).json({
      success: false,
      message: 'Login failure',
    });
  }
};
