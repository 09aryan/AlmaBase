const mongoose = require("mongoose");

exports.dbConnect = () => {
    mongoose.connect('mongodb+srv://24aaryan00:UYZndHzEVqOuoNVy@cluster0.zkqdao7.mongodb.net/', {
    }).then(() => {
        console.log("Connected to database");
    }).catch((err) => {
        console.log("DB connection error:", err);
    });
};
