module.exports = {
    globals: {
        'ts-jest': {
            isolatedModules: true,
            tsconfig: {
                module: 'commonjs',
                moduleResolution: 'node10',
                ignoreDeprecations: '6.0',
            },
        },
    },
    testMatch: [
        '**/test/**/*.spec.(js|ts)',
    ],
    transform: {
        '^.+\\.(ts|tsx|js|jsx)$': 'ts-jest',
    },
    collectCoverage: true,
    coverageDirectory: './coverage',
    coverageThreshold: {
        global: {
            branches: 98,
            functions: 100,
            lines: 100,
            statements: 100,
        },
    },
    collectCoverageFrom: [
        'src/**/*.ts',
        '!**/node_modules/**',
    ],
    setupFilesAfterEnv: ['./test/setup.cjs'],
    roots: [
        'test/',
    ],
    moduleDirectories: [
        'node_modules',
        __dirname,
    ],
};