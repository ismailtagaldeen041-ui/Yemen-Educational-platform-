#!/usr/bin/env node
/**
 * Sample ingestion script (Node.js)
 * - Reads JSON dataset (seed_sample_universities.json)
 * - Calls POST /api/v1/admin/universities/upsert for each university
 * - On success, publishes event to Kafka topic "university.events"
 *
 * Prereqs:
 * - set ENV: API_BASE, API_TOKEN, KAFKA_BROKERS (comma separated)
 */

const fs = require('fs');
const axios = require('axios');
const { Kafka } = require('kafkajs');

const API_BASE = process.env.API_BASE || 'http://localhost:3000/api/v1';
const API_TOKEN = process.env.API_TOKEN || '';
const KAFKA_BROKERS = (process.env.KAFKA_BROKERS || 'localhost:9092').split(',');

const kafka = new Kafka({ clientId: 'ingest-script', brokers: KAFKA_BROKERS });
const producer = kafka.producer();

async function publishEvent(event) {
  await producer.connect();
  await producer.send({
    topic: 'university.events',
    messages: [{ key: event.id, value: JSON.stringify(event) }]
  });
  await producer.disconnect();
}

async function upsertUniversity(univ) {
  const url = `${API_BASE}/admin/universities/upsert`;
  const resp = await axios.post(url, univ, {
    headers: { Authorization: `Bearer ${API_TOKEN}` }
  });
  return resp.data;
}

async function run() {
  const data = JSON.parse(fs.readFileSync('./seed/seed_sample_universities.json', 'utf8'));
  for (const u of data.universities) {
    try {
      console.log('Upserting', u.slug);
      const res = await upsertUniversity(u);
      console.log('Upserted id', res.id);
      // publish event to kafka
      const event = { id: res.id, type: 'university.upsert', payload: { id: res.id, slug: u.slug } };
      await publishEvent(event);
      console.log('Published event for', res.id);
    } catch (err) {
      console.error('Failed upsert', u.slug, err.message);
    }
  }
}

run().catch(err => console.error(err));
