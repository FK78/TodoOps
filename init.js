db.getSiblingDB('todoops').createUser({
    user: process.env.MONGO_APP_USER,
    pwd: process.env.MONGO_APP_PASS,
    roles: [{ role: "readWrite", db: "todoops" }],
})