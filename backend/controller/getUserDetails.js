const User = require('../models/userSchema');

exports.getUserDetails = async (req, res) => {
  try {
    const userId = req.params.userId;

    const user = await User.findById(userId, 'profilepic userName bio points')
      .populate('stories', 'text image video createdAt')
      .populate({
        path: 'posts',
        select: '_id caption location media createdAt tags taggedUsers',
        populate: {
          path: 'likes comments',
          select: 'user text createdAt',
          populate: {
            path: 'user',
            select: 'userName profilepic',
          },
        },
      });

    if (!user) {
      return res.status(404).json({
        success: false,
        message: 'User not found',
      });
    }

    return res.status(200).json({
      success: true,
      user,
    });
  } catch (err) {
    console.error(err);
    return res.status(500).json({
      success: false,
      message: 'Error fetching user details',
    });
  }
};
