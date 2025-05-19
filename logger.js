// logger.js - Example configuration to send frontend logs to the ELK Stack

class Logger {
    constructor() {
      this.apiEndpoint = 'http://localhost:5000'; // Logstash endpoint
      this.applicationName = 'frontend-app';
      this.batchSize = 10;
      this.flushInterval = 5000; // 5 seconds
      this.pendingLogs = [];
      this.setupPeriodicFlush();
    }
  
    setupPeriodicFlush() {
      setInterval(() => {
        this.flush();
      }, this.flushInterval);
  
      // Also try to send logs before the page unloads
      window.addEventListener('beforeunload', () => {
        this.flush();
      });
    }
  
    log(level, message, context = {}) {
      const logEntry = {
        timestamp: new Date().toISOString(),
        level: level.toUpperCase(),
        message,
        service: this.applicationName,
        ...context,
        user: this.getCurrentUser(),
        url: window.location.href,
        userAgent: navigator.userAgent
      };
  
      this.pendingLogs.push(logEntry);
  
      // If batch size reached, send immediately
      if (this.pendingLogs.length >= this.batchSize) {
        this.flush();
      }
  
      // For debugging, also print to console
      console[level.toLowerCase()](message, context);
    }
  
    getCurrentUser() {
      // Custom implementation to get the current user
      // e.g.: return localStorage.getItem('user_id') || 'anonymous';
      return 'anonymous';
    }
  
    async flush() {
      if (this.pendingLogs.length === 0) return;
  
      const logsToSend = [...this.pendingLogs];
      this.pendingLogs = [];
  
      try {
        // Send logs in batch
        const response = await fetch(this.apiEndpoint, {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
          },
          body: JSON.stringify(logsToSend.length === 1 ? logsToSend[0] : logsToSend),
        });
  
        if (!response.ok) {
          console.error('Failed to send logs', response.statusText);
        }
      } catch (error) {
        console.error('Error sending logs to Logstash', error);
        // In case of failure, re-queue and retry later
        this.pendingLogs = [...logsToSend, ...this.pendingLogs];
      }
    }
  
    // Helpers for different log levels
    info(message, context = {}) {
      this.log('INFO', message, context);
    }
  
    warn(message, context = {}) {
      this.log('WARN', message, context);
    }
  
    error(message, context = {}) {
      this.log('ERROR', message, context);
    }
  
    debug(message, context = {}) {
      this.log('DEBUG', message, context);
    }
  }
  
  // Export a singleton instance of the logger
  export const logger = new Logger();
  
  // import { logger } from './logger';
  
  // // Usage examples
  // logger
  