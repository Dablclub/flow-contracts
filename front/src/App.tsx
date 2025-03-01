import React from 'react';
import { useState, useEffect } from 'react';
import * as fcl from "@onflow/fcl";
import styled from 'styled-components';
import "./config/fcl";

const Container = styled.div`
  max-width: 800px;
  margin: 0 auto;
  padding: 20px;
`;

const Button = styled.button`
  background-color: #00ff9f;
  color: black;
  border: none;
  padding: 10px 20px;
  margin: 5px;
  border-radius: 5px;
  cursor: pointer;
  &:hover {
    background-color: #00cc7f;
  }
`;

const Card = styled.div`
  background-color: white;
  border-radius: 10px;
  padding: 20px;
  margin: 20px 0;
  box-shadow: 0 2px 4px rgba(0,0,0,0.1);
`;

function App() {
  const [user, setUser] = useState<{ addr: string | null }>({ addr: null });
  const [status, setStatus] = useState("");

  useEffect(() => {
    fcl.currentUser().subscribe(setUser);
  }, []);

  const login = () => {
    fcl.authenticate();
  };

  const logout = () => {
    fcl.unauthenticate();
  };

  return (
    <Container>
      <h1>Flow Token & NFT Minter</h1>
      
      {user.addr ? (
        <Card>
          <h3>Connected Address: {user.addr}</h3>
          <Button onClick={logout}>Logout</Button>
        </Card>
      ) : (
        <Card>
          <Button onClick={login}>Connect Wallet</Button>
        </Card>
      )}

      {status && (
        <Card>
          <p>{status}</p>
        </Card>
      )}
    </Container>
  );
}

export default App; 