// src/logger.ts
import winston from "winston";
import chalk from "chalk";
import packagejson from "../package.json" with { type: "json" };

// Custom log levels with colors
const logLevels = {
    error: 0,
    warn: 1,
    info: 2,
    http: 3,
    debug: 4,
};

const logColors = {
    error: "red",
    warn: "yellow",
    info: "green",
    http: "magenta",
    debug: "gray",
};

const consoleFormat = winston.format.combine(
    winston.format.timestamp({ format: "YYYY-MM-DD HH:mm:ss.SSS" }),
    winston.format.errors({ stack: true }),
    winston.format.printf(({ timestamp, level, message, stack, ...meta }) => {
        const colorMap: Record<string, (text: string) => string> = {
            error: chalk.red,
            warn: chalk.yellow,
            info: chalk.green,
            http: chalk.magenta,
            debug: chalk.gray,
        };

        const colorFn = colorMap[level] || chalk.white;
        const levelPadded = level.toUpperCase().padEnd(5);

        let logLine = `${chalk.gray(timestamp)} ${colorFn(
            `[${levelPadded}]`
        )} ${chalk.cyan(`[${meta["namespace"]}]`)} ${message}`;

        if (stack) {
            logLine += `\n${chalk.red("Stack:")} ${stack}`;
        }

        return logLine;
    })
);

const fileFormat = winston.format.combine(
    winston.format.timestamp({ format: "YYYY-MM-DD HH:mm:ss.SSS" }),
    winston.format.errors({ stack: true }),
    winston.format.json()
);

const logger = winston.createLogger({
    levels: logLevels,
    level: process.env["LOG_LEVEL"] || "info",
    defaultMeta: {
        service: "localplayers-backend",
        version: packagejson.version,
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
export const mklog = (namespace: string) => ({
    error: (message: string, meta?: Record<string, unknown>) =>
        logger.error(message, { namespace, ...meta }),
    warn: (message: string, meta?: Record<string, unknown>) =>
        logger.warn(message, { namespace, ...meta }),
    info: (message: string, meta?: Record<string, unknown>) =>
        logger.info(message, { namespace, ...meta }),
    http: (message: string, meta?: Record<string, unknown>) =>
        logger.http(message, { namespace, ...meta }),
    debug: (message: string, meta?: Record<string, unknown>) =>
        logger.debug(message, { namespace, ...meta }),
});

export default logger;
