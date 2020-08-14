const Discord = require("discord.js");
const client = new Discord.Client();

const roleId = "743708039533690941";
const channelId = "743709965469876244";

client.on("ready", () => {
  client.channels.fetch(channelId).then((channel) => {
    channel.send(`<@&${roleId}> Hello here's your daily ping.`);
  });
});

client.login(process.env.TOKEN);
