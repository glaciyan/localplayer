// src/logger.ts
import winston from "winston";
import chalk from "chalk";
import { version } from "../package.json";

// Custom log levels with colors
const logLevels = {
    error: 0,
    warn: 1,
    info: 2,
    http: 3,
    debug: 4,
    trace: 5,
};

const logColors = {
    error: "red",
    warn: "yellow",
    info: "green",
    http: "magenta",
    debug: "blue",
    trace: "gray",
};

// Custom format for console output with colors
const consoleFormat = winston.format.combine(
    winston.format.timestamp({ format: "YYYY-MM-DD HH:mm:ss.SSS" }),
    winston.format.errors({ stack: true }),
    winston.format.printf(({ timestamp, level, message, stack }) => {
        // Color mapping
        const colorMap: Record<string, (text: string) => string> = {
            error: chalk.red,
            warn: chalk.yellow,
            info: chalk.green,
            http: chalk.magenta,
            debug: chalk.blue,
            trace: chalk.gray,
        };

        const colorFn = colorMap[level] || chalk.white;
        const levelPadded = level.toUpperCase().padEnd(5);

        // Process ID and hostname for additional context
        const pid = process.pid;
        const hostname = require("os").hostname();

        let logLine = `${chalk.gray(timestamp)} ${colorFn(
            `[${levelPadded}]`
        )} ${chalk.cyan(`[${hostname}:${pid}]`)} ${message}`;

        // Add stack trace for errors
        if (stack) {
            logLine += `\n${chalk.red("Stack:")} ${stack}`;
        }

        return logLine;
    })
);

// File format without colors (for log files)
const fileFormat = winston.format.combine(
    winston.format.timestamp({ format: "YYYY-MM-DD HH:mm:ss.SSS" }),
    winston.format.errors({ stack: true }),
    winston.format.json()
);

// Create the logger
const logger = winston.createLogger({
    levels: logLevels,
    level: process.env["LOG_LEVEL"] || "info",
    defaultMeta: {
        service: "localplayers-backend",
        version: version,
        environment: process.env["NODE_ENV"] || "development",
    },
    transports: [
        // Console transport with colors
        new winston.transports.Console({
            format: consoleFormat,
        }),

        // File transport for all logs
        new winston.transports.File({
            filename: "logs/app.log",
            format: fileFormat,
            maxsize: 5242880, // 5MB
            maxFiles: 5,
        }),

        // Separate file for errors only
        new winston.transports.File({
            filename: "logs/error.log",
            level: "error",
            format: fileFormat,
            maxsize: 5242880, // 5MB
            maxFiles: 5,
        }),
    ],
});

// Add colors to Winston
winston.addColors(logColors);

// Create logs directory if it doesn't exist
import fs from "fs";
import path from "path";

const logsDir = path.join(process.cwd(), "logs");
if (!fs.existsSync(logsDir)) {
    fs.mkdirSync(logsDir, { recursive: true });
}

// Export logger with typed methods
export const log = {
    error: (message: string, meta?: Record<string, unknown>) =>
        logger.error(message, meta),
    warn: (message: string, meta?: Record<string, unknown>) =>
        logger.warn(message, meta),
    info: (message: string, meta?: Record<string, unknown>) =>
        logger.info(message, meta),
    http: (message: string, meta?: Record<string, unknown>) =>
        logger.http(message, meta),
    debug: (message: string, meta?: Record<string, unknown>) =>
        logger.debug(message, meta),
};

export default logger;
