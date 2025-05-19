# ELK Stack for Frontend Logging and Monitoring

This repository contains configuration files to set up an ELK (Elasticsearch, Logstash, Kibana) stack for frontend log monitoring and visualization. The setup is designed to be easy to use, with a focus on developer experience through a comprehensive Makefile.

## Overview

This project provides:

- Dockerized ELK stack (Elasticsearch, Logstash, Kibana)
- Configuration for frontend log ingestion via HTTP
- Example JavaScript logger for frontend applications
- Makefile with common development commands

## File Structure

```
.
├── docker-compose.yml        # Docker Compose configuration for all services
├── Dockerfile                # Elasticsearch Dockerfile (optional, uses official images by default)
├── logstash.conf             # Logstash pipeline configuration
├── logstash.yml              # Logstash main configuration
├── logger.js                 # Example frontend logger implementation
├── Makefile                  # Helper commands for development
└── README.md                 # This documentation file
```

## Prerequisites

- Docker and Docker Compose
- Make (for using the Makefile commands)

## Quick Start

1. Clone this repository
2. Run `make start` to start the ELK stack
3. Access Kibana at http://localhost:5601
4. Configure a Data View in Kibana (see below)
5. Send test logs with `make test-log`

## Makefile Commands

The Makefile provides several convenient commands to help manage the ELK environment:

| Command | Description |
|---------|-------------|
| `make setup` | Creates necessary directories and copies configuration files |
| `make start` | Sets up and starts all ELK stack containers |
| `make stop` | Stops all running containers |
| `make restart` | Restarts all containers |
| `make logs` | Shows container logs (useful for debugging) |
| `make status` | Displays the status of all containers |
| `make clean` | Stops containers and removes volumes (cleans all data) |
| `make test-log` | Sends a test log to Logstash for verification |
| `make help` | Shows available commands and their descriptions |

## Configuring Kibana Data View

After starting the ELK stack, you need to configure a Data View in Kibana to visualize your logs:

1. Open Kibana in your browser: http://localhost:5601
2. Navigate to Stack Management → Data Views
3. Click "Create data view"
4. Set the following:
   - Name: "Frontend Logs"
   - Index pattern: `frontend-logs-*`
   - Timestamp field: `timestamp`
5. Click "Save data view"
6. Go to "Discover" in the main menu to see your logs

## Frontend Integration

The `logger.js` file provides an example of how to integrate your frontend application with the ELK stack. This logger:

- Batches logs for efficient sending
- Automatically flushes logs at regular intervals
- Includes contextual information (user, page URL, etc.)
- Supports different log levels (info, warn, error, debug)
- Handles send failures gracefully

### Basic Usage Example

```javascript
// Import the logger
import { logger } from './logger';

// Log different types of events
logger.info('User logged in', { userId: 'user123' });
logger.warn('Feature is deprecated', { featureId: 'old-feature' });
logger.error('API request failed', { endpoint: '/api/data', statusCode: 500 });

// Catch unhandled errors
window.addEventListener('error', (event) => {
  logger.error('Unhandled error', { 
    message: event.message,
    filename: event.filename,
    lineno: event.lineno,
    stack: event.error?.stack
  });
});
```

## Customizing the Setup

### Elasticsearch

Elasticsearch is configured as a single-node cluster for development purposes. For production, you should:

- Enable security features
- Configure proper authentication
- Set up a multi-node cluster
- Add persistent storage

### Logstash

The default Logstash configuration accepts HTTP inputs and parses JSON logs. You can customize the pipeline by modifying `logstash.conf` with additional filters or outputs.

### Kibana

Kibana is set up with default settings. For production, consider:

- Setting up authentication
- Configuring TLS/SSL
- Creating saved dashboards and visualizations

## Troubleshooting

If you encounter issues:

1. Check container status with `make status`
2. View logs with `make logs`
3. Ensure Elasticsearch is healthy before Kibana and Logstash start
4. Verify your network configuration allows connections to all required ports
5. Try sending a test log with `make test-log` to confirm connectivity

## Production Considerations

For production environments:

- Enable security features (X-Pack)
- Configure proper authentication
- Implement a reverse proxy with TLS/SSL
- Set up proper backup strategies
- Configure appropriate resource limits
- Consider using managed ELK services

## License

[MIT License](LICENSE)
