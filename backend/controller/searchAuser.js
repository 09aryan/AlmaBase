const User = require('../models/userSchema');

const searchUsersByUsername = async (req, res) => {
  const { userName } = req.params;

  console.log('Searching for users with partial userName:', userName);

  try {
    const users = await User.find(
      { userName: { $regex: new RegExp(userName, 'i') } },
      'userName profilepic'
    );

    if (users.length === 0) {
      return res.status(404).json({
        success: false,
        message: 'No users found with the provided userName.',
        users: [],
      });
    }

    res.status(200).json({
      success: true,
      users,
    });
  } catch (error) {
    console.error('Error searching users:', error);
    res.status(500).json({
      success: false,
      message: 'Internal Server Error',
      error: error.message,
    });
  }
};

module.exports = {
  searchUsersByUsername,
};
