// const mongoose = require("mongoose");

// const messageSchema = mongoose.Schema(
//   {
//     sender: { type: mongoose.Schema.Types.ObjectId, ref: "User" },
//     content: { type: String, trim: true },
//     chat: { type: mongoose.Schema.Types.ObjectId, ref: "Chat" },
//     readBy: [{ type: mongoose.Schema.Types.ObjectId, ref: "User" }],
//   },
//   { timestamps: true }
// );

// const Message = mongoose.model("Message", messageSchema);
// module.exports = Message;
const mongoose = require("mongoose");

const messageSchema = mongoose.Schema(
  {
    sender: { type: mongoose.Schema.Types.ObjectId, ref: "User" },
    content: { type: String, trim: true },
    mediaType: { type: String, enum: ["text", "image", "video", "other"] },
    mediaURLs: [{ type: String }], // Array to store multiple media URLs
    chat: { type: mongoose.Schema.Types.ObjectId, ref: "Chat" },
    readBy: [{ type: mongoose.Schema.Types.ObjectId, ref: "User" }],
  },
  { timestamps: true }
);


const Message = mongoose.model("Message", messageSchema);
module.exports = Message;
