declare module '@onflow/fcl' {
  export function config(): {
    put: (key: string, value: string) => any;
  };
  
  export function authenticate(): Promise<any>;
  export function unauthenticate(): Promise<any>;
  export function currentUser(): {
    subscribe: (callback: (user: any) => void) => void;
  };
  
  export function mutate(params: {
    cadence: string;
    args?: (arg: any, t: any) => any[];
    limit?: number;
  }): Promise<any>;
  
  export function tx(transactionId: string): {
    onceSealed: () => Promise<any>;
  };
}

declare module '@onflow/types' {
  export const UFix64: any;
  export const Address: any;
} 