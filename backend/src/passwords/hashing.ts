import * as argon2 from "argon2";

interface AsyncHasher {
    hash(str: string): Promise<string>;
    verify(hash: string, str: string): Promise<boolean>;
}

const argon2id = {
    hash: function (str: string): Promise<string> {
        return argon2.hash(str);
    },
    verify: function (hash: string, str: string): Promise<boolean> {
        return argon2.verify(hash, str);
    }
} satisfies AsyncHasher;

export const hasher: AsyncHasher = argon2id;