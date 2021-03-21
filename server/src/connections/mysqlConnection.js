import { Sequelize } from 'sequelize';
import mysql2 from 'mysql2';
import DebugLib from 'debug';

const MYSQL_HOST = process.env.MYSQL_HOST || 'localhost';
const MYSQL_PORT = process.env.MYSQL_PORT || '3306';
const MYSQL_DATABASE = process.env.MYSQL_DATABASE || 'eoloplantsDB';
const MYSQL_USER = process.env.MYSQL_USER || 'root';
const MYSQL_PASS = process.env.MYSQL_PASS || 'password';

const debug = new DebugLib('server:mysql');

export default new Sequelize(MYSQL_DATABASE, MYSQL_USER, MYSQL_PASS, {
    host: MYSQL_HOST,
    port: MYSQL_PORT,
    dialect: 'mysql',
    dialectModule: mysql2,
    logging: false
});

process.on('exit', async () => {
    await sequelize.close();
    debug(`Closing mysql connection`);
});
