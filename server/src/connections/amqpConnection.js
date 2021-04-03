import { connect } from 'amqplib';
import DebugLib from 'debug';
import configHandler from '../clients/plannerNotificationHandler.js';

const RABBITMQ_PROTOCOL = process.env.RABBITMQ_PROTOCOL || 'amqp'
const RABBITMQ_HOST = process.env.RABBITMQ_HOST || 'localhost';
const RABBITMQ_PORT = process.env.RABBITMQ_PORT || '5672';
const RABBITMQ_USER = process.env.RABBITMQ_USER || 'root';
const RABBITMQ_PASS = process.env.RABBITMQ_PASS || 'password';

const debug = new DebugLib('server:amqp');

export let amqpChannel;

export async function connectAmqp() {
  
  const URL = `${RABBITMQ_PROTOCOL}://${RABBITMQ_USER}:${RABBITMQ_PASS}@${RABBITMQ_HOST}:${RABBITMQ_PORT}`;

  const conn = await connect(URL);
  amqpChannel = await conn.createChannel();
  
  configHandler(amqpChannel);

  process.on('exit', () => {
    amqpChannel.close();
    debug(`Closing rabbitmq channel`);
  });
}
