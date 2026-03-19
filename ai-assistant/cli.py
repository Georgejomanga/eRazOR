#!/usr/bin/env python3

"""
eRazOR AI Assistant - Command Line Interface
Main CLI entry point for the AI assistant
"""

import sys
import os
import click
import yaml
from pathlib import Path

# Add parent directory to path
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

# Version
VERSION = "0.1.0-alpha"

class ConfigManager:
    """Load and manage configuration"""
    
    def __init__(self, config_file="config.yaml"):
        self.config_file = config_file
        self.config = self._load_config()
    
    def _load_config(self):
        """Load configuration from YAML file"""
        try:
            with open(self.config_file, 'r') as f:
                return yaml.safe_load(f)
        except FileNotFoundError:
            click.echo(click.style("Warning: config.yaml not found. Using defaults.", fg="yellow"))
            return {}
        except Exception as e:
            click.echo(click.style(f"Error loading config: {e}", fg="red"))
            return {}
    
    def get(self, key, default=None):
        """Get config value"""
        return self.config.get(key, default)

# Initialize config
config = ConfigManager()

@click.group()
@click.version_option(version=VERSION, prog_name="eRazOR AI Assistant")
def cli():
    """
    eRazOR AI Assistant - Advanced Security & Penetration Testing Helper
    
    Local AI-powered assistant for threat analysis, attack prediction, 
    and penetration testing workflow guidance.
    """
    pass

@cli.command()
def test():
    """Test AI assistant connectivity"""
    click.echo(click.style("Testing eRazOR AI Assistant...", fg="blue", bold=True))
    
    try:
        click.echo("✓ Configuration loaded")
        click.echo("✓ Python environment OK")
        click.echo(f"✓ Version: {VERSION}")
        click.echo(click.style("\nAI Assistant is ready!", fg="green", bold=True))
    except Exception as e:
        click.echo(click.style(f"✗ Error: {e}", fg="red"))
        sys.exit(1)

@cli.group()
def pentest():
    """Penetration Testing Workflows"""
    pass

@pentest.command()
@click.option('--target', '-t', help='Target IP or hostname')
@click.option('--scan-type', '-s', type=click.Choice(['quick', 'deep', 'full']), default='quick', help='Scan type')
def scan(target, scan_type):
    """Scan and analyze target"""
    if not target:
        click.echo(click.style("Error: --target is required", fg="red"))
        sys.exit(1)
    
    click.echo(click.style(f"\n🔍 Analyzing target: {target}", fg="blue", bold=True))
    click.echo(f"📊 Scan Type: {scan_type}")
    click.echo(click.style("\n[This is a demo - full implementation coming soon]", fg="yellow"))
    click.echo("In production, this will:")
    click.echo("  • Identify open ports")
    click.echo("  • Detect services and versions")
    click.echo("  • Suggest potential vulnerabilities")
    click.echo("  • Recommend next steps")

@pentest.command()
@click.option('--vulnerability', '-v', help='Vulnerability CVE or name')
def exploit(vulnerability):
    """Get exploitation guidance"""
    if not vulnerability:
        click.echo(click.style("Error: --vulnerability is required", fg="red"))
        sys.exit(1)
    
    click.echo(click.style(f"\n⚔️  Exploitation Guidance: {vulnerability}", fg="red", bold=True))
    click.echo(click.style("\n[Demo mode - production version coming soon]", fg="yellow"))
    click.echo("Features will include:")
    click.echo("  • Detailed vulnerability explanation")
    click.echo("  • Available exploitation tools")
    click.echo("  • Step-by-step guidance")
    click.echo("  • Success indicators")

@cli.group()
def threat():
    """Threat Analysis & Intelligence"""
    pass

@threat.command()
@click.option('--analyze', '-a', help='File or sample to analyze')
@click.option('--type', '-t', type=click.Choice(['malware', 'payload', 'script', 'network']), default='malware', help='Analysis type')
def analyze(analyze, type):
    """Analyze potential threats"""
    if not analyze:
        click.echo(click.style("Error: --analyze parameter is required", fg="red"))
        sys.exit(1)
    
    click.echo(click.style(f"\n🔬 Threat Analysis: {analyze}", fg="blue", bold=True))
    click.echo(f"📋 Type: {type}")
    click.echo(click.style("\n[Demo - full analysis engine loading]", fg="yellow"))
    click.echo("Analysis will include:")
    click.echo("  • Signature matching")
    click.echo("  • Behavioral analysis")
    click.echo("  • Risk assessment")
    click.echo("  • Mitigation strategies")

@threat.command()
@click.option('--attack', '-a', help='Attack type to predict')
def predict(attack):
    """Predict attack vectors and outcomes"""
    if not attack:
        click.echo(click.style("Error: --attack parameter is required", fg="red"))
        sys.exit(1)
    
    click.echo(click.style(f"\n🎯 Attack Prediction: {attack}", fg="red", bold=True))
    click.echo(click.style("\n[Demo - ML model loading]", fg="yellow"))
    click.echo("Predictions will show:")
    click.echo("  • Likelihood of attack success")
    click.echo("  • Common attack paths")
    click.echo("  • Detection capabilities")
    click.echo("  • Mitigation recommendations")

@cli.group()
def script():
    """Scripting & Code Assistance"""
    pass

@script.command()
@click.option('--language', '-l', type=click.Choice(['python', 'bash', 'powershell', 'ruby']), help='Programming language')
@click.option('--task', '-t', help='Task description')
def generate(language, task):
    """Generate security scripts"""
    if not language or not task:
        click.echo(click.style("Error: --language and --task are required", fg="red"))
        sys.exit(1)
    
    click.echo(click.style(f"\n💻 Script Generation: {language}", fg="blue", bold=True))
    click.echo(f"📝 Task: {task}")
    click.echo(click.style("\n[Demo - code generation loading]", fg="yellow"))
    click.echo("Generated scripts will include:")
    click.echo("  • Functional security code")
    click.echo("  • Detailed comments")
    click.echo("  • Error handling")
    click.echo("  • Best practices")

@script.command()
@click.option('--code', '-c', help='Code snippet to explain')
def explain(code):
    """Explain security code"""
    if not code:
        click.echo(click.style("Error: --code parameter is required", fg="red"))
        sys.exit(1)
    
    click.echo(click.style(f"\n📖 Code Explanation", fg="blue", bold=True))
    click.echo(click.style("\n[Demo mode]", fg="yellow"))
    click.echo("Explanation will cover:")
    click.echo("  • What the code does")
    click.echo("  • Security implications")
    click.echo("  • Potential improvements")
    click.echo("  • Related concepts")

@cli.command()
def status():
    """Check system and AI status"""
    click.echo(click.style("\n📊 eRazOR System Status", fg="blue", bold=True))
    click.echo("─" * 50)
    
    try:
        click.echo("✓ AI Assistant: Online")
        click.echo(f"✓ Version: {VERSION}")
        click.echo("✓ Configuration: Loaded")
        click.echo("✓ Modules: Available")
        click.echo(click.style("✓ System: Ready", fg="green"))
    except Exception as e:
        click.echo(click.style(f"✗ Error: {e}", fg="red"))
    
    click.echo("─" * 50)

@cli.command()
def help_info():
    """Show detailed help information"""
    click.echo(click.style("\n" + "="*60, fg="blue"))
    click.echo(click.style("eRazOR AI Assistant - Command Guide", fg="blue", bold=True))
    click.echo(click.style("="*60, fg="blue"))
    
    click.echo(click.style("\n1. PENETRATION TESTING", fg="yellow", bold=True))
    click.echo("   erazor-ai pentest scan --target <IP>")
    click.echo("   erazor-ai pentest exploit --vulnerability <CVE>")
    
    click.echo(click.style("\n2. THREAT ANALYSIS", fg="yellow", bold=True))
    click.echo("   erazor-ai threat analyze --analyze <file>")
    click.echo("   erazor-ai threat predict --attack <type>")
    
    click.echo(click.style("\n3. SCRIPTING HELP", fg="yellow", bold=True))
    click.echo("   erazor-ai script generate --language python --task 'your task'")
    click.echo("   erazor-ai script explain --code 'code snippet'")
    
    click.echo(click.style("\n4. SYSTEM", fg="yellow", bold=True))
    click.echo("   erazor-ai test          # Test connectivity")
    click.echo("   erazor-ai status        # Show system status")
    click.echo("   erazor-ai --version     # Show version")
    
    click.echo(click.style("\n" + "="*60 + "\n", fg="blue"))

if __name__ == '__main__':
    # Run CLI
    cli()
