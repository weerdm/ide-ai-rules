#!/usr/bin/env node

/**
 * Trengo Frontend - Integration Hub CSS Fix Script
 * 
 * This script automatically locates Vue components with mb-6 classes on input elements
 * and fixes them by moving the margin to container elements.
 * 
 * Usage: node scripts/fix-mb6-inputs.js [--dry-run] [--verbose]
 */

const fs = require('fs');
const path = require('path');
const { exec } = require('child_process');

// Configuration
const SRC_DIR = './src';
const BACKUP_DIR = `./src_backup_${new Date().toISOString().slice(0, 19).replace(/[:-]/g, '')}`;

// Command line arguments
const args = process.argv.slice(2);
const isDryRun = args.includes('--dry-run');
const isVerbose = args.includes('--verbose');

// Colors for console output
const colors = {
  red: '\x1b[31m',
  green: '\x1b[32m',
  yellow: '\x1b[33m',
  blue: '\x1b[34m',
  magenta: '\x1b[35m',
  cyan: '\x1b[36m',
  reset: '\x1b[0m'
};

/**
 * Log messages with colors
 */
function log(message, color = 'reset') {
  console.log(`${colors[color]}${message}${colors.reset}`);
}

/**
 * Find all Vue files in the src directory
 */
function findVueFiles(dir) {
  const files = [];
  
  function traverse(currentDir) {
    const items = fs.readdirSync(currentDir);
    
    for (const item of items) {
      const fullPath = path.join(currentDir, item);
      const stat = fs.statSync(fullPath);
      
      if (stat.isDirectory() && !item.startsWith('.') && item !== 'node_modules') {
        traverse(fullPath);
      } else if (stat.isFile() && item.endsWith('.vue')) {
        files.push(fullPath);
      }
    }
  }
  
  traverse(dir);
  return files;
}

/**
 * Check if a Vue file contains problematic mb-6 patterns
 */
function analyzeVueFile(filePath) {
  const content = fs.readFileSync(filePath, 'utf8');
  const issues = [];
  
  // Patterns to find
  const patterns = [
    {
      name: 'mb-6 on input element',
      regex: /<input[^>]*class="[^"]*mb-6[^"]*"[^>]*>/g,
      type: 'input-mb6'
    },
    {
      name: 'input with name="webshop_domain"',
      regex: /<input[^>]*name="webshop_domain"[^>]*>/g,
      type: 'webshop-domain'
    },
    {
      name: 'input with shop domain placeholder',
      regex: /<input[^>]*placeholder="[^"]*shop domain[^"]*"[^>]*>/gi,
      type: 'shop-domain-placeholder'
    }
  ];
  
  // Check each pattern
  patterns.forEach(pattern => {
    let match;
    while ((match = pattern.regex.exec(content)) !== null) {
      const lineNumber = content.substring(0, match.index).split('\n').length;
      issues.push({
        type: pattern.type,
        name: pattern.name,
        line: lineNumber,
        match: match[0],
        index: match.index
      });
    }
  });
  
  return {
    filePath,
    content,
    issues,
    hasIssues: issues.length > 0
  };
}

/**
 * Fix the mb-6 issues in a Vue file
 */
function fixVueFile(analysis) {
  let { content } = analysis;
  let modified = false;
  
  // Fix 1: Remove mb-6 from input classes and wrap in container
  const inputMb6Regex = /<input([^>]*class="[^"]*)(mb-6)([^"]*"[^>]*>)/g;
  content = content.replace(inputMb6Regex, (match, before, mb6, after) => {
    modified = true;
    // Remove mb-6 from the class
    const newClasses = before.replace(/\s*mb-6\s*/g, ' ').trim();
    const fixedInput = `<input${newClasses}${after}`;
    
    // Check if input is already wrapped in a div
    const beforeInput = content.substring(0, content.indexOf(match));
    const afterInput = content.substring(content.indexOf(match) + match.length);
    
    // Simple check - if there's a recent div before this input, don't double-wrap
    const recentDiv = beforeInput.lastIndexOf('<div');
    const recentCloseDiv = beforeInput.lastIndexOf('</div>');
    
    if (recentDiv > recentCloseDiv) {
      // Likely already in a div, just remove mb-6
      return fixedInput;
    } else {
      // Wrap in a new div with mb-6
      return `<div class="mb-6">\n      ${fixedInput}\n    </div>`;
    }
  });
  
  // Fix 2: Specific webshop domain input fixes
  const webshopDomainRegex = /<input([^>]*name="webshop_domain"[^>]*class="[^"]*)(mb-6)([^"]*"[^>]*>)/g;
  content = content.replace(webshopDomainRegex, (match, before, mb6, after) => {
    modified = true;
    const cleaned = before.replace(/\s*mb-6\s*/g, ' ');
    return `<div class="mb-6">\n      <input${cleaned}${after}\n    </div>`;
  });
  
  return {
    content,
    modified
  };
}

/**
 * Create backup of source directory
 */
function createBackup() {
  if (!isDryRun) {
    log(`Creating backup: ${BACKUP_DIR}`, 'yellow');
    exec(`cp -r ${SRC_DIR} ${BACKUP_DIR}`, (error) => {
      if (error) {
        log(`Error creating backup: ${error.message}`, 'red');
      } else {
        log(`Backup created successfully`, 'green');
      }
    });
  }
}

/**
 * Main execution function
 */
function main() {
  log('🔍 Trengo Frontend - Integration Hub CSS Fix', 'cyan');
  log('============================================', 'cyan');
  
  if (!fs.existsSync(SRC_DIR)) {
    log(`❌ Error: ${SRC_DIR} directory not found`, 'red');
    log('Please run this script from the Trengo frontend root directory.', 'red');
    process.exit(1);
  }
  
  if (isDryRun) {
    log('🧪 DRY RUN MODE - No files will be modified', 'yellow');
  } else {
    createBackup();
  }
  
  log('📍 Searching for Vue files...', 'blue');
  const vueFiles = findVueFiles(SRC_DIR);
  log(`Found ${vueFiles.length} Vue files`, 'blue');
  
  const problematicFiles = [];
  let totalIssues = 0;
  
  // Analyze each Vue file
  for (const filePath of vueFiles) {
    const analysis = analyzeVueFile(filePath);
    
    if (analysis.hasIssues) {
      problematicFiles.push(analysis);
      totalIssues += analysis.issues.length;
      
      log(`\n📄 ${filePath}`, 'yellow');
      analysis.issues.forEach(issue => {
        log(`  Line ${issue.line}: ${issue.name}`, 'red');
        if (isVerbose) {
          log(`    ${issue.match}`, 'magenta');
        }
      });
    }
  }
  
  if (problematicFiles.length === 0) {
    log('\n✅ No problematic mb-6 patterns found!', 'green');
    return;
  }
  
  log(`\n🔧 Found ${totalIssues} issues in ${problematicFiles.length} files`, 'yellow');
  
  if (!isDryRun) {
    log('\n🛠️  Applying fixes...', 'blue');
    
    let fixedFiles = 0;
    let fixedIssues = 0;
    
    for (const analysis of problematicFiles) {
      const result = fixVueFile(analysis);
      
      if (result.modified) {
        fs.writeFileSync(analysis.filePath, result.content, 'utf8');
        fixedFiles++;
        fixedIssues += analysis.issues.length;
        log(`✅ Fixed: ${analysis.filePath}`, 'green');
      }
    }
    
    log(`\n🎉 Fixed ${fixedIssues} issues in ${fixedFiles} files`, 'green');
    log('📋 Next steps:', 'blue');
    log('  1. Test the integration hub in your browser', 'blue');
    log('  2. Verify input alignment is correct', 'blue');
    log('  3. Check all integrations work properly', 'blue');
    log(`  4. If needed, restore from backup: mv ${BACKUP_DIR} ${SRC_DIR}`, 'blue');
  } else {
    log('\n📋 To apply fixes, run without --dry-run flag', 'blue');
  }
}

// Execute the script
main();