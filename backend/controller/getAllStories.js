// const Story = require('../models/Story');

const Story = require("../models/storySchema");

// const User = require('../models/User');
const getAllStoriesWithDetails = async (req, res) => {
  try {
    // Get all stories with user details
    const stories = await Story.find().populate({
      path: 'user',
      model: 'User',
      select: 'userName profilepic',
    });
     console.log(stories);
    res.status(200).json({ success: true, stories });
  } catch (error) {
    console.error('Error fetching stories:', error);
    res.status(500).json({ success: false, error: 'Internal Server Error' });
  }
};

module.exports = { getAllStoriesWithDetails };
