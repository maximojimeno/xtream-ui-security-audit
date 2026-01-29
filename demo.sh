#!/bin/bash
# Script de demostración de vulnerabilidades
# Solo para fines educativos y auditorías autorizadas

echo "╔══════════════════════════════════════════════════════════════╗"
echo "║                                                              ║"
echo "║     🔐 DEMO DE VULNERABILIDADES - Xtream UI                  ║"
echo "║                                                              ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Función para pausar
pause() {
    echo ""
    echo -e "${YELLOW}Presiona ENTER para continuar...${NC}"
    read
}

# 1. Mostrar documentación
echo -e "${BLUE}[1/5]${NC} Documentación disponible:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
ls -lh *.md 2>/dev/null | awk '{print "  📄", $9, "(" $5 ")"}'
pause

# 2. Mostrar scripts de explotación
echo ""
echo -e "${BLUE}[2/5]${NC} Scripts de explotación:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
ls -lh exploits/*.py 2>/dev/null | awk '{print "  🔧", $9, "(" $5 ")"}'
pause

# 3. DEMO: Mostrar payloads de command injection
echo ""
echo -e "${BLUE}[3/5]${NC} Demo: Command Injection PoC"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo -e "${YELLOW}Ejecutando: python exploits/command_injection_poc.py${NC}"
echo ""
python exploits/command_injection_poc.py 2>/dev/null || echo -e "${RED}Error: Verificar Python${NC}"
pause

# 4. DEMO: Mostrar payloads SQL
echo ""
echo -e "${BLUE}[4/5]${NC} Demo: SQL Injection PoC"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo -e "${YELLOW}Ejecutando: python exploits/sql_injection_poc.py${NC}"
echo ""
python exploits/sql_injection_poc.py 2>/dev/null || echo -e "${RED}Error: Verificar Python${NC}"
pause

# 5. Resumen
echo ""
echo -e "${BLUE}[5/5]${NC} Resumen de Vulnerabilidades"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo -e "${RED}🔴 Críticas:${NC}  4 vulnerabilidades"
echo "   - Command Injection (CVSS 9.8)"
echo "   - SQL Injection (CVSS 9.1)"
echo "   - Weak Encryption (CVSS 8.9)"
echo "   - Hardcoded Credentials (CVSS 9.8)"
echo ""
echo -e "${YELLOW}🟠 Altas:${NC}     3 vulnerabilidades"
echo "   - Insecure Downloads (CVSS 8.1)"
echo "   - Privilege Escalation (CVSS 7.8)"
echo "   - Insecure Permissions (CVSS 7.5)"
echo ""
echo -e "${GREEN}🟡 Medias:${NC}    8+ vulnerabilidades"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo -e "${GREEN}✅ Para más detalles:${NC}"
echo "   - Lee SECURITY_AUDIT_README.md para inicio rápido"
echo "   - Lee EXECUTIVE_SUMMARY.md para resumen ejecutivo"
echo "   - Lee VULNERABILITIES_REPORT.md para análisis técnico"
echo ""
echo -e "${RED}⚠️  IMPORTANTE:${NC}"
echo "   Solo usar con autorización explícita"
echo "   El uso no autorizado es ILEGAL"
echo ""
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║            ✅ Demo completada exitosamente                   ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""
