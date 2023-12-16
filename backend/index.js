const express = require('express');
const router = require('./routes/routes');
const app = express();

require("./config/database").dbConnect();
const cloudinaryConnect = require('../backend/config/cloudinary');
const Chat = require('./models/chatModels');
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use('/app/v1', router);

 const server=app.listen(1000, '0.0.0.0', () => {
    console.log(`App is running 1000`);
});

const io = require('socket.io')(server, {
    pingTimeout: 60000,
    cors: {
        origin: ["http://127.0.0.1:59936", "http://localhost:59936", "*"],
    },
});
// const io = require('socket.io')(server, {
//     pingTimeout: 60000,
//     cors: {
//         origin: ["*"],
//     },
// });

io.on("connection", (socket) => {
    console.log("Connected to socket.io");

    socket.on("setup", (userData) => {
        socket.join(userData._id);
        socket.emit("connected");
    });

    socket.on("join chat", (room) => {
        socket.join(room);
        console.log("User Joined Room: " + room);
    });

    socket.on("new message", async (newMessageRecieved) => {
        try {
            const chatId = newMessageRecieved.chatId;
    
            if (!chatId) {
                console.log("chatId not defined");
                console.log("newMessageRecieved:", newMessageRecieved);
                return;
            }
    
            const chat = await Chat.findById(chatId).populate('users');
    
            console.log("Received message in chat:", chat);
    
            if (!chat || !chat.users) {
                console.log("chat or chat.users not defined");
                console.log("newMessageRecieved:", newMessageRecieved);
                return;
            }
    
            chat.users.forEach((user) => {
                if (user._id.toString() !== newMessageRecieved.senderId.toString()) {
                    socket.in(user._id.toString()).emit("message received", newMessageRecieved);
                }
            });
        } catch (error) {
            console.error("Error fetching chat:", error);
        }
    });
    
    

    socket.on("disconnect", () => {
        console.log("USER DISCONNECTED");
        socket.leaveAll(); // Leave all rooms
        socket.removeAllListeners(); // Remove all event listeners
    });
});
