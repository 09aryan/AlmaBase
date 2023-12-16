// authMiddleware.js

const jwt = require('jsonwebtoken');

const authMiddleware = (req, res, next) => {
  // Get the token from the request header
  const token = req.header('Authorization');

  if (!token) {
    return res.status(401).json({ error: 'Authorization denied' });
  }

  try {

     const decoded = jwt.decode(token, { complete: true });

    req.user = decoded.payload; 


    next();
  } catch (error) {
    res.status(401).json({ error: 'Invalid token' });
  }
};

module.exports = authMiddleware;
